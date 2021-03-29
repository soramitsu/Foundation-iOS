/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation

class BigNumberFormatterTests: XCTestCase {
    let abbreviations: [BigNumberAbbreviation] = [
        .defaultInitial,
        .defaultThousands,
        .defaultMillions,
        .defaultBillions
    ]

    func testValidaFormatting() {
        let formatter = BigNumberFormatter(abbreviations: abbreviations)

        XCTAssertEqual(formatter.string(for: Decimal(598)), "598")
        XCTAssertEqual(formatter.string(for: Decimal(1000)), "1K")
        XCTAssertEqual(formatter.string(for: Decimal(9940)), "9.9K")
        XCTAssertEqual(formatter.string(for: Decimal(9980)), "10K")
        XCTAssertEqual(formatter.string(for: Decimal(39900)), "39.9K")
        XCTAssertEqual(formatter.string(for: Decimal(99880)), "99.9K")
        XCTAssertEqual(formatter.string(for: Decimal(399880)), "0.4M")
        XCTAssertEqual(formatter.string(for: Decimal(999898)), "1M")
        XCTAssertEqual(formatter.string(for: Decimal(999999)), "1M")
        XCTAssertEqual(formatter.string(for: Decimal(1456384)), "1.5M")
        XCTAssertEqual(formatter.string(for: Decimal(12383474)), "12.4M")
        XCTAssertEqual(formatter.string(for: Decimal(123_834_745)), "0.1B")
        XCTAssertEqual(formatter.string(for: Decimal(166_834_745)), "0.2B")
        XCTAssertEqual(formatter.string(for: Decimal(1_238_347_456)), "1.2B")
    }
}
