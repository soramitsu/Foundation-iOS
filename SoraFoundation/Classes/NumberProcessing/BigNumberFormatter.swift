/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

public class BigNumberFormatter: Formatter {
    private let numberFormatter: NumberFormatter
    private let abbreviations: [BigNumberAbbreviation]

    public init(abbreviations: [BigNumberAbbreviation], precision: UInt8 = 1) {
        self.abbreviations = abbreviations.sorted { abb1, abb2 in abb1.threshold < abb2.threshold }

        numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = Int(precision)
        numberFormatter.roundingMode = .halfUp

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func string(for obj: Any?) -> String? {
        if let decimalValue = obj as? Decimal {
            return string(from: decimalValue)
        }

        return nil
    }

    public func string(from decimal: Decimal) -> String? {
        guard decimal >= 0, !abbreviations.isEmpty else {
            return nil
        }

        var index = abbreviations.firstIndex { decimal < $0.threshold } ?? abbreviations.count
        index = max(0, index - 1)

        let abbreviation = abbreviations[index]

        let result = decimal / abbreviation.divisor

        guard let string = numberFormatter.string(from: result as NSNumber) else {
            return nil
        }

        return string + abbreviation.suffix
    }
}
