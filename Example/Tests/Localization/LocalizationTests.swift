/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import XCTest
import SoraFoundation
import SoraKeystore

class LocalizationTests: XCTestCase {
    private struct Constants {
        static let russian = "ru"
        static let english = "en"
        static let spanish = "es"
        static let settingsKey = "language"
        static let russiaRegion = "RU"
        static let usRegion = "US"
        static let spainRegion = "ES"
        static let defaultTimeout: TimeInterval = 10.0
    }

    func testObserverIsNotifiedWhenLocalizationChanges() {
        // given

        let localizationManager = LocalizationManager(localization: Constants.russian)!

        XCTAssertEqual(localizationManager.selectedLocalization, Constants.russian)

        // when

        let changeExpectation = XCTestExpectation()

        localizationManager.addObserver(with: self, queue: .main) { (old, new) in
            changeExpectation.fulfill()
        }

        localizationManager.selectedLocalization = Constants.english

        // then

        wait(for: [changeExpectation], timeout: Constants.defaultTimeout)

        XCTAssertEqual(localizationManager.selectedLocalization, Constants.english)
    }

    func testObserverCanBeAddAndRemoved() {
        // given

        let localizationManager = LocalizationManager(localization: Constants.russian)!

        // when

        localizationManager.addObserver(with: self, queue: .main) { (_, _) in }

        // then

        XCTAssertEqual(localizationManager.observers.count, 1)
        XCTAssertTrue(localizationManager.observers.first?.owner === self)

        // when

        localizationManager.removeObserver(by: self)

        // then

        XCTAssertTrue(localizationManager.observers.isEmpty)
    }

    func testLocalizationIsSavedToSettings() {
        // given

        let settings = InMemorySettingsManager()

        let localizationManager = LocalizationManager(settings: settings, key: Constants.settingsKey)

        XCTAssertEqual(localizationManager.selectedLocalization,
                       settings.string(for: Constants.settingsKey))

        // when

        localizationManager.selectedLocalization = Constants.russian

        // then

        XCTAssertEqual(localizationManager.selectedLocalization, Constants.russian)
        XCTAssertEqual(settings.string(for: Constants.settingsKey), Constants.russian)
    }

    func testLocalizationFetchedFromSettings() {
        // given

        let settings = InMemorySettingsManager()
        settings.set(value: Constants.spanish, for: Constants.settingsKey)

        // when

        let localizationManager = LocalizationManager(settings: settings,
                                                      key: Constants.settingsKey,
                                                      preferredLanguages: [Constants.russian],
                                                      availableLocalizations: [Constants.russian])

        // then

        XCTAssertEqual(localizationManager.selectedLocalization, settings.string(for: Constants.settingsKey))
    }

    func testDefaultLanguageIsUsedIfLocaleMatchingFailed() {
        // given

        let settings = InMemorySettingsManager()

        // when

        let localizationManager = LocalizationManager(settings: settings,
                                                      key: Constants.settingsKey,
                                                      preferredLanguages: [Constants.russian],
                                                      availableLocalizations: [Constants.english],
                                                      defaultLocalization: Constants.spanish)

        // then

        XCTAssertEqual(localizationManager.selectedLocalization, Constants.spanish)
    }

    func testAvailableLocalizationIsFullyMatchesPreferred() {
        // given

        let settings = InMemorySettingsManager()

        let spanishUsComponents = [
            NSLocale.Key.languageCode.rawValue: Constants.spanish,
            NSLocale.Key.countryCode.rawValue: Constants.usRegion
        ]

        let spanishUs = Locale.identifier(fromComponents: spanishUsComponents)

        // when

        let localizationManager = LocalizationManager(settings: settings,
                                                      key: Constants.settingsKey,
                                                      preferredLanguages: [Constants.russian, spanishUs, Constants.spanish],
                                                      availableLocalizations: [spanishUs],
                                                      defaultLocalization: Constants.english)

        // then

        XCTAssertEqual(localizationManager.selectedLocalization, spanishUs)
    }

    func testAvailableLocalizationIsPartiallyMatchesPreferred() {
        // given

        let settings = InMemorySettingsManager()

        let spanishUsComponents = [
            NSLocale.Key.languageCode.rawValue: Constants.spanish,
            NSLocale.Key.countryCode.rawValue: Constants.usRegion
        ]

        let spanishUs = Locale.identifier(fromComponents: spanishUsComponents)

        // when

        let localizationManager = LocalizationManager(settings: settings,
                                                      key: Constants.settingsKey,
                                                      preferredLanguages: [Constants.russian, spanishUs, Constants.english],
                                                      availableLocalizations: [Constants.spanish],
                                                      defaultLocalization: Constants.english)

        // then

        XCTAssertEqual(localizationManager.selectedLocalization, Constants.spanish)
    }

    func testPreferredLocalizationIsPartiallyMatchesAvailable() {
        // given

        let settings = InMemorySettingsManager()

        let spanishUsComponents = [
            NSLocale.Key.languageCode.rawValue: Constants.spanish,
            NSLocale.Key.countryCode.rawValue: Constants.usRegion
        ]

        let spanishUs = Locale.identifier(fromComponents: spanishUsComponents)

        // when

        let localizationManager = LocalizationManager(settings: settings,
                                                      key: Constants.settingsKey,
                                                      preferredLanguages: [Constants.russian, Constants.spanish, Constants.english],
                                                      availableLocalizations: [spanishUs],
                                                      defaultLocalization: Constants.english)

        // then

        XCTAssertEqual(localizationManager.selectedLocalization, spanishUs)
    }
}
