//
//  File.swift
//  
//
//

import Foundation
import Domain

class ImageLoaderWithFallbackComposite: ImageLoader {
    private let primary: ImageLoader
    private let fallback: ImageLoader
    
    init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load(completion: @escaping (ImageLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
