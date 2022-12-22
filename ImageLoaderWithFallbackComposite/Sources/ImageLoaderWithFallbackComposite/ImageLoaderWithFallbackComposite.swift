//
//  File.swift
//  
//
//

import Foundation
import Domain

public class ImageLoaderWithFallbackComposite: ImageLoader {
    private let primary: ImageLoader
    private let fallback: ImageLoader
    
    public init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (ImageLoader.Result) -> Void) {
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
