//
//  FullScreenImageView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 18.5.23..
//

import SwiftUI
import SDWebImageSwiftUI
import SFSafeSymbols

struct FullScreenImageView<Content: View>: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let urls: [String]
    var content: (String) -> Content
    
    @State private var currentPage = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $currentPage) {
                    ForEach(urls.indices) { index in
                        content(urls[index])
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .scaledToFit()
                            .id(urls[index])
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 250)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide the default TabView indicators
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Display only the PageIndexView
                
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Image(systemSymbol: .arrowBackward)
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        
                        Spacer()
                    }
                    .padding([.top, .leading])
                    
                    Spacer()
                    
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
            .background(.black)
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = .gray
        }
    }
}
