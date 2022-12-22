//
//  CompositePatternExampleApp.swift
//  CompositePatternExample
//
//  Created by testUser on 22/12/2022.
//

import SwiftUI
import ImageLoaderWithFallbackComposite
import Networking

@main
struct CompositePatternExampleApp: App {
    let contentView = UIComposer.viewComposedWith(imageLoader: ImageLoaderWithFallbackComposite(
        primary: LocalImageLoader(),
        fallback: ImageLoaderWithFallbackComposite(
            primary: LocalImageLoader(),
            fallback: RemoteImageLoader())))
    
    var body: some Scene {
        WindowGroup {
            contentView
        }
    }
}
