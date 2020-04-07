import Foundation

/**
 *  Preprocessor that cuts prefix of the input string until reaches
 *  a character not from particular character set.
 *
 *  For example the following example outputs 'swift'
 *  ````
 *  let preprocessor = PrefixCharacterPreprocessor(charset: CharacterSet(charactersIn: "-"))
 *  print(preprocessor.preprocess(text: "--swift"))
 *  ````
 */

public struct PrefixCharacterPreprocessor: InputViewModelPreprocessing {
    public let charset: CharacterSet

    public init(charset: CharacterSet) {
        self.charset = charset
    }

    public func preprocess(text: String) -> String {
        let characters = text.unicodeScalars.reduce(String.UnicodeScalarView()) { result, character in
            if charset.contains(character), result.isEmpty {
                return result
            } else {
                return result + [character]
            }
        }

        return String(characters)
    }
}
