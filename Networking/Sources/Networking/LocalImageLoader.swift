//
//  File.swift
//  
//
//

import Foundation
import Domain

public class LocalImageLoader: ImageLoader {
    public init() { }
    public func load(completion: @escaping (ImageLoader.Result) -> Void) {
        completion(.failure(NSError(domain: "any error", code: 0)))
    }
}

