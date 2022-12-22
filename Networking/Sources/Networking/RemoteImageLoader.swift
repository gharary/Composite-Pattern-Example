//
//  File.swift
//  
//
//

import Foundation
import Domain

public class RemoteImageLoader: ImageLoader {
    public init() { }
    public func load(completion: @escaping (ImageLoader.Result) -> Void) {
        let image = [ImageItem(id: UUID(), description: "any description", url: URL(string: "https://picsum.photos/200")!),
                     ImageItem(id: UUID(), description: "any description", url: URL(string: "https://picsum.photos/200")!)]
        completion(.success(image))
    }
}
