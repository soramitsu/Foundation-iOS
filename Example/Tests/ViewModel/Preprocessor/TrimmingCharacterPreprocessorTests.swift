/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation

class TrimmingCharacterPreprocessorTests: XCTestCase {
    func testPrefixErasure() {
        let preprocessor = TrimmingCharacterProcessor(charset: CharacterSet(charactersIn: "-+"))

        XCTAssertEqual(preprocessor.process(text: "---swift"), "swift")
        XCTAssertEqual(preprocessor.process(text: "++swift++"), "swift")
        XCTAssertEqual(preprocessor.process(text: "''swift"), "''swift")
        XCTAssertEqual(preprocessor.process(text: "swift---"), "swift")
        XCTAssertEqual(preprocessor.process(text: "+++"), "")
        XCTAssertEqual(preprocessor.process(text: ""), "")
    }
}
