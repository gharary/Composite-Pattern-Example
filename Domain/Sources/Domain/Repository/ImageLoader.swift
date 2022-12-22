//
//  File.swift
//  
//
//

import Foundation

public protocol ImageLoader {
    typealias Result = Swift.Result<[ImageItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
