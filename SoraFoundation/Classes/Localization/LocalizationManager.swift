/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import SoraKeystore

public typealias LocalizationChangeClosure = (String, String) -> Void

public protocol LocalizationManagerProtocol: class {
    var selectedLocalization: String { get set }

    var availableLocalizations: [String] { get }

    func addObserver(with owner: AnyObject,
                     queue: DispatchQueue?,
                     closure: @escaping LocalizationChangeClosure)

    func removeObserver(by owner: AnyObject)
}

public extension LocalizationManagerProtocol {
    var selectedLocale: Locale {
        var components = Locale.components(fromIdentifier: Locale.current.identifier)
        components[NSLocale.Key.languageCode.rawValue] = selectedLocalization

        return Locale(identifier: Locale.identifier(fromComponents: components))
    }

    func addObserver(with owner: AnyObject, closure: @escaping LocalizationChangeClosure) {
        addObserver(with: owner, queue: nil, closure: closure)
    }
}

public final class LocalizationManager: LocalizationManagerProtocol {
    public struct ObserverWrapper {
        public weak var owner: AnyObject?
        public let closure: LocalizationChangeClosure
        public let queue: DispatchQueue?
    }

    public private(set) var settings: SettingsManagerProtocol?
    public private(set) var settingsKey: String?

    public private(set) var observers: [ObserverWrapper] = []

    public var selectedLocalization: String {
        didSet {
            if oldValue != selectedLocalization {

                if let settings = settings, let settingsKey = settingsKey {
                    settings.set(value: selectedLocalization, for: settingsKey)
                }

                notify(oldLocalization: oldValue, newLocalization: selectedLocalization)
            }
        }
    }

    public var availableLocalizations: [String] {
        return Bundle.main.localizations
    }

    public init(settings: SettingsManagerProtocol,
                key: String,
                preferredLanguages: [String] = Locale.preferredLanguages,
                availableLocalizations: [String] = Bundle.main.localizations,
                defaultLocalization: String = "en") {
        self.settings = settings
        self.settingsKey = key

        if let localization = settings.string(for: key) {
            self.selectedLocalization = localization
        } else {
            let localization = LocalizationManager
                .determineSuitableLocalization(for: preferredLanguages,
                                               availableLocalizations: availableLocalizations) ?? defaultLocalization

            self.settings?.set(value: localization, for: key)
            self.selectedLocalization = localization
        }
    }

    public init?(localization: String) {
        let components = Locale.components(fromIdentifier: localization)

        guard components[NSLocale.Key.languageCode.rawValue] != nil else {
            return nil
        }

        self.selectedLocalization = localization
    }

    public func addObserver(with owner: AnyObject,
                     queue: DispatchQueue?,
                     closure: @escaping LocalizationChangeClosure) {
        observers.append(ObserverWrapper(owner: owner,
                                         closure: closure,
                                         queue: queue))

        observers = observers.filter { $0.owner !== nil }
    }

    public func removeObserver(by owner: AnyObject) {
        observers = observers.filter { $0.owner !== owner && $0.owner !== nil}
    }

    private func notify(oldLocalization: String, newLocalization: String) {
        observers = observers.filter { $0.owner !== nil }

        observers.forEach { wrapper in
            if wrapper.owner != nil {
                if let queue = wrapper.queue {
                    queue.async {
                        wrapper.closure(oldLocalization, newLocalization)
                    }
                } else {
                    wrapper.closure(oldLocalization, newLocalization)
                }
            }
        }
    }

    private static func determineSuitableLocalization(for preferredLanguages: [String],
                                                      availableLocalizations: [String]) -> String? {

        let fullmatchLocalization = availableLocalizations.first {
            return preferredLanguages.contains($0)
        }

        if fullmatchLocalization != nil {
            return fullmatchLocalization
        }

        for availableLocalization in availableLocalizations {
            let availableComponents = Locale.components(fromIdentifier: availableLocalization)

            guard let availableLanguage = availableComponents[NSLocale.Key.languageCode.rawValue] else {
                return nil
            }

            for preferredLanguage in preferredLanguages {
                let preferredComponent = Locale.components(fromIdentifier: preferredLanguage)

                if availableLanguage == preferredComponent[NSLocale.Key.languageCode.rawValue] {
                    return availableLocalization
                }
            }
        }

        return nil
    }
}
