import XCTest
import SoraFoundation

class TrimmingCharacterPreprocessorTests: XCTestCase {
    func testPrefixErasure() {
        let preprocessor = TrimmingCharacterPreprocessor(charset: CharacterSet(charactersIn: "-+"))

        XCTAssertEqual(preprocessor.preprocess(text: "---swift"), "swift")
        XCTAssertEqual(preprocessor.preprocess(text: "++swift++"), "swift")
        XCTAssertEqual(preprocessor.preprocess(text: "''swift"), "''swift")
        XCTAssertEqual(preprocessor.preprocess(text: "swift---"), "swift")
        XCTAssertEqual(preprocessor.preprocess(text: "+++"), "")
        XCTAssertEqual(preprocessor.preprocess(text: ""), "")
    }
}
