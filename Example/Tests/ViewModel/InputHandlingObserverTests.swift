/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation

class InputHandlingObserverTests: XCTestCase {
    private final class ObserverMock: InputHandlingObserver {
        var calledCount: Int = 0

        func didChangeInputValue(_ handler: InputHandling, from oldValue: String) {
            calledCount += 1
        }
    }

    func testObserverCalledAfterInput() {
        // given

        let observer = ObserverMock()

        let inputHandler = InputHandler()

        // when

        inputHandler.addObserver(observer)

        _ = inputHandler.didReceiveReplacement("some changes", for: NSRange(location: 0, length: 0))

        // then

        XCTAssertEqual(observer.calledCount, 1)
    }

    func testObserverCalledAfterChangeValue() {
        // given

        let observer = ObserverMock()

        let inputHandler = InputHandler()

        // when

        inputHandler.addObserver(observer)

        inputHandler.changeValue(to: "some changes")

        // then

        XCTAssertEqual(observer.calledCount, 1)
    }

    func testObserverCalledAfterClearValue() {
        // given

        let observer = ObserverMock()

        let inputHandler = InputHandler()

        // when

        inputHandler.addObserver(observer)

        _ = inputHandler.didReceiveReplacement("some changes", for: NSRange(location: 0, length: 0))
        inputHandler.clearValue()

        // then

        XCTAssertEqual(observer.calledCount, 2)
    }
}
