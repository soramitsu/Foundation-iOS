/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation

class LocalizableResourceTests: XCTestCase {
    func testNumberFormatters() {
        let localizations = [
            LocalizationConstants.english,
            LocalizationConstants.russian,
            LocalizationConstants.spanish,
        ]

        let value: Decimal = 12345.67

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true

        for language in localizations {
            guard let localizationManager = LocalizationManager(localization: language) else {
                XCTFail("Can't create localization manager for \(language)")
                continue
            }

            let formattedValue = numberFormatter.localizableResource()
                .value(for: localizationManager.selectedLocale)
                .string(from: value as NSNumber)

            XCTAssertNotNil(formattedValue)
        }
    }
}
