import XCTest
import SoraFoundation

class PrefixCharacterPreprocessorTests: XCTestCase {

    func testPrefixErasure() {
        let preprocessor = PrefixCharacterProcessor(charset: CharacterSet(charactersIn: "-+"))

        XCTAssertEqual(preprocessor.process(text: "---swift"), "swift")
        XCTAssertEqual(preprocessor.process(text: "++swift"), "swift")
        XCTAssertEqual(preprocessor.process(text: "''swift"), "''swift")
        XCTAssertEqual(preprocessor.process(text: "swift---"), "swift---")
        XCTAssertEqual(preprocessor.process(text: "+++"), "")
        XCTAssertEqual(preprocessor.process(text: ""), "")
    }

}
