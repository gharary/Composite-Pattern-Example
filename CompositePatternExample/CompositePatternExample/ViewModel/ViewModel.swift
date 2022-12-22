//
//  ViewModel.swift
//  CompositePatternExample
//
//

import Foundation
import Domain
import Combine

public final class ViewModel: ObservableObject {
    private let imageLoader: ImageLoader
    
    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
    }
    
    @Published var images: [ImageItem] = []
    
    public func loadImages() {
        imageLoader.load { [weak self] result in
            if let images = try? result.get() {
                self?.images = images
            }
        }
    }
}
