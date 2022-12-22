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
        let image = [ImageItem(id: UUID(), description: "any description", url: URL(string: "https://source.unsplash.com/user/c_v_r/200x200")!),
                     ImageItem(id: UUID(), description: "any description", url: URL(string: "https://source.unsplash.com/user/c_v_r/200x200")!)]
        completion(.success(image))
    }
}
