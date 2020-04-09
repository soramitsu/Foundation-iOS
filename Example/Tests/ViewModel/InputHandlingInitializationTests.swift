/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation

class InputHandlingInitializationTests: XCTestCase {
    func testMinLengthAdjustedWhenInitialValueLess() {
        let inputHandler = InputHandler(value: "123", minLength: 4)
        XCTAssertEqual(inputHandler.minLength, 3)
    }

    func testMinLengthNotAdjustedWhenInitialValueNotLess() {
        let inputHandler = InputHandler(value: "123", minLength: 1)
        XCTAssertEqual(inputHandler.minLength, 1)
    }

    func testMaxLengthAdjustedWhenInitialValueGreater() {
        let inputHandler = InputHandler(value: "123", maxLength: 2)
        XCTAssertEqual(inputHandler.maxLength, 3)
    }

    func testMinLengthNotAdjustedWhenInitialValueNotGreater() {
        let inputHandler = InputHandler(value: "123", maxLength: 4)
        XCTAssertEqual(inputHandler.maxLength, 4)
    }
}
