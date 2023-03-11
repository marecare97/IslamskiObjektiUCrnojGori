//
//  PaginView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI
import SDWebImageSwiftUI

struct PagingView<Content: View>: View {
    let urls: [String]
    var content: (String) -> Content
    
    @State private var currentPage = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(urls.indices) { index in
                        content(urls[index])
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .scaledToFit()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                
                HStack(spacing: 8) {
                    ForEach(urls.indices) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(currentPage == index ? .white : .gray)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = .gray
        }
    }
}

struct RemoteImage: View {
    var url: String
    
    var body: some View {
        WebImage(url: URL(string: url))
            .resizable()
            .placeholder(Image(systemName: "photo"))
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
    }
}
