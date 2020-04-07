import Foundation

/**
 *  Preprocessor that trims provided text.
 *
 *  For example the following example outputs 'swift'
 *  ````
 *  let preprocessor = TrimmingCharacterPreprocessor(charset: CharacterSet(charactersIn: "-"))
 *  print(preprocessor.preprocess(text: "--swift--"))
 *  ````
 */

public struct TrimmingCharacterPreprocessor: InputViewModelPreprocessing {
    public let charset: CharacterSet

    public init(charset: CharacterSet) {
        self.charset = charset
    }

    public func preprocess(text: String) -> String {
        return text.trimmingCharacters(in: charset)
    }
}
