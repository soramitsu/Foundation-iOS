import XCTest
import SoraFoundation

class PrefixCharacterPreprocessorTests: XCTestCase {

    func testPrefixErasure() {
        let preprocessor = PrefixCharacterPreprocessor(charset: CharacterSet(charactersIn: "-+"))

        XCTAssertEqual(preprocessor.preprocess(text: "---swift"), "swift")
        XCTAssertEqual(preprocessor.preprocess(text: "++swift"), "swift")
        XCTAssertEqual(preprocessor.preprocess(text: "''swift"), "''swift")
        XCTAssertEqual(preprocessor.preprocess(text: "swift---"), "swift---")
        XCTAssertEqual(preprocessor.preprocess(text: "+++"), "")
        XCTAssertEqual(preprocessor.preprocess(text: ""), "")
    }

}
