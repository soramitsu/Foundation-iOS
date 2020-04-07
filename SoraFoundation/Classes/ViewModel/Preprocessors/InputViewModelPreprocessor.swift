import Foundation

public protocol InputViewModelPreprocessing {
    func preprocess(text: String) -> String
}

public struct CompoundViewModelPreprocessor: InputViewModelPreprocessing {
    public let children: [InputViewModelPreprocessing]

    public init(children: [InputViewModelPreprocessing]) {
        self.children = children
    }

    public func preprocess(text: String) -> String {
        children.reduce(text) { result, preprocessor in
            preprocessor.preprocess(text: result)
        }
    }
}
