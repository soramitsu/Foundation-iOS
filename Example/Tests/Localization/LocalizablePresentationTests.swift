/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation

class LocalizablePresentationTests: XCTestCase {
    private class LocalizablePresenter: LocalizablePresentation {
        private(set) var applyLocalizationCount = 0
        private(set) var didChangeLocalizationCount = 0

        func applyLocalization() {
            applyLocalizationCount += 1
        }

        func didChangeLocalizationManager(from oldManager: LocalizationManagerProtocol?, to newManager: LocalizationManagerProtocol?) {
            didChangeLocalizationCount += 1
        }
    }

    func testDelegateIsCalledWhenLanguageChanges() {
        // given

        let localizationManager = LocalizationManager(localization: LocalizationConstants.russian)
        let presenter = LocalizablePresenter()

        // when

        presenter.localizationManager = localizationManager
        localizationManager?.selectedLocalization = LocalizationConstants.english

        // then

        XCTAssertEqual(presenter.applyLocalizationCount, 1)
        XCTAssertEqual(presenter.didChangeLocalizationCount, 1)
    }
}
