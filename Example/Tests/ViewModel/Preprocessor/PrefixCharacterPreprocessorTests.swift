/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

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
