/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

public protocol LocalizablePresentation: class {
    var localizationManager: LocalizationManagerProtocol? { get set }

    func applyLocalization()

    func didChangeLocalizationManager(from oldManager: LocalizationManagerProtocol?,
                                      to newManager: LocalizationManagerProtocol?)
}

private struct LocalizableConstants {
    static var localizationManagerKey = "co.jp.sora.localizable.manager"
}

public extension LocalizablePresentation {
    var localizationManager: LocalizationManagerProtocol? {
        set {

            let currentManager = localizationManager

            guard newValue !== currentManager else {
                return
            }

            currentManager?.removeObserver(by: self)

            newValue?.addObserver(with: self) { [weak self] (_, _) in
                self?.applyLocalization()
            }

            objc_setAssociatedObject(self,
                                     &LocalizableConstants.localizationManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)

            didChangeLocalizationManager(from: currentManager, to: newValue)
        }

        get {
            return objc_getAssociatedObject(self, &LocalizableConstants.localizationManagerKey)
                as? LocalizationManagerProtocol
        }
    }

    func didChangeLocalizationManager(from oldManager: LocalizationManagerProtocol?,
                                      to newManager: LocalizationManagerProtocol?) {}
}
