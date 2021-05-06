/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation

class DynamicPrecisionNumberFormatterTests: XCTestCase {
    func testValidateFormatting() {
        let formatter = DynamicPrecisionFormatter(preferredPrecision: 4, roundingMode: .down)
        formatter.locale = Locale(identifier: "en")

        XCTAssertEqual(formatter.stringFromDecimal(0.1234), "0.1234")
        XCTAssertEqual(formatter.stringFromDecimal(0.12345), "0.1234")
        XCTAssertEqual(formatter.stringFromDecimal(0.123), "0.123")
        XCTAssertEqual(formatter.stringFromDecimal(0), "0")
        XCTAssertEqual(formatter.stringFromDecimal(1234.12345), "1234.1234")
        XCTAssertEqual(formatter.stringFromDecimal(1234.00001), "1234")
        XCTAssertEqual(formatter.stringFromDecimal(0.00001), "0.00001")
        XCTAssertEqual(formatter.stringFromDecimal(0.0000111), "0.00001")
        XCTAssertEqual(formatter.stringFromDecimal(0.0000000000213123), "0.00000000002")
    }
}
