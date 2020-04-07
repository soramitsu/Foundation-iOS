import UIKit

/**
 *  Protocol designed to provide interface for view model of input fields
 */

public protocol InputViewModelProtocol {
    /// Returns ```true``` if current value is valid otherwise ```false```.
    var completed: Bool { get }

    /**
     *  Returns ```true``` if current value required to be valid.
     *
     *  This flag is simplifies logic when current view model is part of a form (set of input view models)
     *  but it is not required for the view model to be valid so that the whole form is valid. Usually a client
     *  just ignores value of not required view models in case ```completed``` property returns ```false```.
     */

    var required: Bool { get }

    /// String to display as title for the field current input view model is bound to.
    var title: String { get }

    /// Current input value

    var value: String { get }

    /**
     *  Flag that state whether current value can be changed via ```didReceiveReplacement``` method.
     *
     *  - note:
     *  This flag has no effect to ```changeValue``` and ```clearValue``` methods.
     */

    var enabled: Bool { get }

    /**
     *  Flag that state whether the input should be autocapitalized.
     *
     *  - note:
     *  This flag has no effect to the value itself. It is just a hint to properly setup input field.
     */

    var autocapitalizationType: UITextAutocapitalizationType { get }

    /**
     *  This method is expected to be called from
     *  ```textField(_:shouldChangeCharactersIn:replacementString)``` delegate method of UITextField or
     *  cooresponding delegate method of UITextView.
     *
     *  - parameters:
     *     - string: String to replace provided range with;
     *     - range: Range to replace in current value;
     *
     *  - Example: A client must update the text of input field in case
     *  the call returs ```false``` and also return ```false``` from the delegate method.
     *
     *    ````
     *    func textField(_ textField: UITextField,
     *                       shouldChangeCharactersIn range: NSRange,
     *                       replacementString string: String) -> Bool {
     *        if !model.didReceiveReplacement(string, for: range) {
     *           textField.text = model.value
     *           return false
     *        }
     *       return true
     *     }
     *    ````
     */

    func didReceiveReplacement(_ string: String, for range: NSRange) -> Bool

    /**
     *  Changes current input value to new one.
     *
     *  - parameters:
     *      - newValue: New value to replace current value with.
     */

    func changeValue(to newValue: String)

    /**
     *  Sets current value as empty string
     */

    func clearValue()
}

/**
 *  Implementation of InputViewModelProtocol that allows:
 *  - filter invalid characters;
 *  - normalize value;
 *  - preprocess client's input;
 *
 *  See corresponding properties for more details.
 *
 *  Typical usage by a client is the following:
 *
 *  ````
 *    func textField(_ textField: UITextField,
 *                       shouldChangeCharactersIn range: NSRange,
 *                       replacementString string: String) -> Bool {
 *        if !model.didReceiveReplacement(string, for: range) {
 *           textField.text = model.value
 *           return false
 *        }
 *       return true
 *     }
 *
 *     ...
 *
 *    @objc func actionTextFieldChange(sender: UITextField) {
 *      if sender.text != model.value {
 *          sender.text = model.value
 *      }
 *    }
 *   ````
 *
 *  - note: It is crucial to check whether text changed as expected using ```actionTextFieldChange``` like
 *  method to process ```.editingChanged``` control event to handle unexpected changes in input text, for example,
 *  introduced by 'swipe to input' feature on iOS 13 or by Japanese (Romaji) keyboard.
 *  However the implemetation can be vise verse:
 *  view model's value can be updated using ```changeValue``` method.
 *  So the main idea is just to keep ```UITextField.text``` and ```value``` sources consistent.
 */

public final class InputViewModel: InputViewModelProtocol {
    public let title: String
    public private(set) var value: String
    public let enabled: Bool
    public let required: Bool
    public let autocapitalizationType: UITextAutocapitalizationType

    /// Invalid character set to filter in ```didReceiveReplacement``` method.
    public let invalidCharacterSet: CharacterSet?

    /**
     *  Maximum number of characters value can contain.
     *
     *  - note:
     *  Restriction is only applied in ```didReceiveReplacement``` method. So make sure that
     *  the value takes into account constraints when changed via ```changeValue``` method.
     */

    public let maxLength: Int

    /**
    *  Minimum number of characters value can contain.
    *
    *  - note:
    *  The restriction is only inforced in ```didReceiveReplacement``` method. So make sure that
    *  the value takes into account constraints when changed via ```changeValue``` method.
    */

    public let minLength: Int

    /**
     *  Predicate to validate current value.
     */

    public let predicate: NSPredicate?

    /**
     *  Preprocesses final input value in ```didReceiveReplacement``` method befor replacement of
     *  current value.
     *
     *  - note:
     *  Current value is preprocessed by ```normalizer``` before validation.
     */
    public let preprocessor: InputViewModelPreprocessing?

    /**
    *  Preprocesses final input value before checking its validity.
    */
    public let normalizer: InputViewModelPreprocessing?

    /// Applies ```normalizer``` (if available) to the current value and returns the result.

    public var normalizedValue: String {
        if let normalizer = normalizer {
            return normalizer.preprocess(text: value)
        } else {
            return value
        }
    }

    /**
     *  - Parameters:
     *      - title: Title to display for input field. By default is **empty string**.
     *      - value: Initial value to start input from. By default is **empty string**.
     *      - required: Flag that states whether it is required for value to be valid
     *      for the whole form to be valid. By default is **true**.
     *      - enabled: Flag that states whether a client can input to the field. Only
     *      ```didReceiveReplacement``` method is affected.
     *      - minLength: Minimum number of characters for input value to be valid. If provided parameter is
     *      less than initial input value length then the last one is set. By default is **0**.
     *      - maxLength: Minimum number of characters for input value to be valid. If provided parameter is
     *      greater than initial input value length then the last one is set. By default is **Int.max**.
     *      - validCharacterSet: Set of characters a client can input. By default is **nil** meaning any character.
     *      - predicate: Predicate to check whether normalized value is valid. By default **nil**
     *      meaning any value is valid.
     *      - preprocessor: Prepocessor is responsible to process the value before replacement of current value.
     *      By default is **nil** meaning no preprocessing.
     *      - normalizer: Preprocessor to process the value before checking its validity. Also normalized value
     *      is available via corresponding property. It can be used, for example, to trim current value.
     *      By default is **nil** meaning no normalization.
     *      - autocapitalizationType: Autocapitalization type to apply to input field.
     *      By default is ```.sentense```.
     */

    public init(title: String = "",
                value: String = "",
                required: Bool = true,
                enabled: Bool = true,
                minLength: Int = 0,
                maxLength: Int = Int.max,
                validCharacterSet: CharacterSet? = nil,
                predicate: NSPredicate? = nil,
                preprocessor: InputViewModelPreprocessing? = nil,
                normalizer: InputViewModelPreprocessing? = nil,
                autocapitalizationType: UITextAutocapitalizationType = .sentences) {
        self.title = title
        self.value = value
        self.required = required
        self.enabled = enabled

        let minLength = min(minLength, maxLength)

        if value.count < minLength {
            self.minLength = value.count
        } else {
            self.minLength = minLength
        }

        let maxLength = max(self.minLength, maxLength)

        if value.count > maxLength {
            self.maxLength = value.count
        } else {
            self.maxLength = maxLength
        }

        self.invalidCharacterSet = validCharacterSet?.inverted
        self.predicate = predicate
        self.preprocessor = preprocessor
        self.normalizer = normalizer

        self.autocapitalizationType = autocapitalizationType
    }

    public var completed: Bool {
        if let predicate = predicate {
            return predicate.evaluate(with: normalizedValue)
        } else {
            return true
        }
    }

    public func clearValue() {
        value = ""
    }

    public func changeValue(to newValue: String) {
        value = newValue
    }

    public func didReceiveReplacement(_ string: String, for range: NSRange) -> Bool {
        guard enabled else {
            return false
        }

        let newValue = (value as NSString).replacingCharacters(in: range, with: string)

        guard newValue.count >= minLength, newValue.count <= maxLength else {
            return false
        }

        guard let currentInvalidSet = invalidCharacterSet,
            string.rangeOfCharacter(from: currentInvalidSet) == nil else {
            return false
        }

        if let preprocessor = preprocessor {
            let preprocessed = preprocessor.preprocess(text: newValue)

            value = preprocessed

            return preprocessed == newValue
        } else {
            value = newValue

            return true
        }
    }
}
