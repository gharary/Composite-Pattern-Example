//
//  File.swift
//  
//
//

import Foundation

public struct ImageItem: Equatable {
    public let id: UUID
    public let description: String?
    public let url: URL
    
    public init(id: UUID, description: String?, url: URL) {
        self.id = id
        self.description = description
        self.url = url
        
    }
}
