//
//  ContentView.swift
//  CompositePatternExample
//
//  Created by testUser on 22/12/2022.
//

import SwiftUI
import Domain

public struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    public var body: some View {
        VStack {
            Text("Composite Pattern Example!")
                .font(.title)
                .foregroundColor(.black)
            ForEach(viewModel.images, id: \.id) { ImageViewItem(imageItem: $0) }
        }
        .onAppear {
            viewModel.loadImages()
        }
    }
    
}

struct ImageViewItem: View {
    
    let imageItem: ImageItem
    
    var body: some View {
        VStack {
            AsyncImage(url: imageItem.url)
                .frame(width: 200, height: 200)
                .scaledToFit()
            if let description = imageItem.description {
                Text(description)
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }.padding()
        .background(Color.red)
    }
}
