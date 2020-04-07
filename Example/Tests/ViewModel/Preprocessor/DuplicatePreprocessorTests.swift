import XCTest
import SoraFoundation

class DuplicateCharacterPreprocessorTests: XCTestCase {
    func testDuplicationsErasure() {
        let preprocessor = DuplicatingCharacterPreprocessor(charset: CharacterSet(charactersIn: "-+"))

        XCTAssertEqual(preprocessor.preprocess(text: "swift---alive"), "swift-alive")
        XCTAssertEqual(preprocessor.preprocess(text: "swift+++alive"), "swift+alive")
        XCTAssertEqual(preprocessor.preprocess(text: "swift'''alive"), "swift'''alive")
        XCTAssertEqual(preprocessor.preprocess(text: "---swift"), "-swift")
        XCTAssertEqual(preprocessor.preprocess(text: "swift---"), "swift-")
        XCTAssertEqual(preprocessor.preprocess(text: "+++"), "+")
        XCTAssertEqual(preprocessor.preprocess(text: ""), "")
    }
}
