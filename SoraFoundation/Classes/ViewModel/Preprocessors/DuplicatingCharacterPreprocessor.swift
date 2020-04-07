import Foundation

/**
 *  Preprocessor that leave only single character from sequence of the same characters
 *
 *  For example the following example outputs 'swift-alive'
 *
 *  ````
 *  let preprocessor = DuplicatingCharacterPreprocessor(charset: CharacterSet(charactersIn: "-"))
 *  print(preprocessor.preprocess(text: "swift---alive"))
 *  ````
 */

public struct DuplicatingCharacterPreprocessor: InputViewModelPreprocessing {
    public let charset: CharacterSet

    public init(charset: CharacterSet) {
        self.charset = charset
    }

    public func preprocess(text: String) -> String {
        let characters = text.unicodeScalars.reduce(String.UnicodeScalarView()) { result, character in
            if charset.contains(character), result.last == character {
                return result
            } else {
                return result + [character]
            }
        }

        return String(characters)
    }
}
