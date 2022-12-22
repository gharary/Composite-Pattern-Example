//
//  UIComposer.swift
//  CompositePatternExample
//
//

import Foundation
import Domain

public final class UIComposer {
    public static func viewComposedWith(imageLoader: ImageLoader) -> ContentView {
        let viewModel = ViewModel(imageLoader: imageLoader)
        let viewController = ContentView.makeWith(viewModel: viewModel)
        
        return viewController
    }
}
extension ContentView {
    static func makeWith(viewModel: ViewModel) -> ContentView {
        return ContentView(viewModel: viewModel)
    }
}
