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
    let objectLat: Double
    let objectLong: Double
    let objectId: Int
    var content: (String) -> Content
    
    @State private var currentPage = 0
    @State private var isFullScreenImageViewPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $currentPage) {
                    ForEach(urls.indices) { index in
                        content(urls[index])
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .scaledToFill()
                            .id(urls[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide the default TabView indicators
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Display only the PageIndexView
                
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(urls.indices) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(currentPage == index ? .black : .gray)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    Spacer()
                    
                    editMenu
                }
                .padding(.trailing)
            }
            .cornerRadius(40, corners: .bottomLeft)
        }
        .fullScreenCover(isPresented: $isFullScreenImageViewPresented) {
            FullScreenImageView(urls: urls) { str in
                RemoteImage(url: str)
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = .gray
        }
    }
    
    var editMenu: some View {
        VStack {
            Button {
                openMap(objectLat: objectLat, objectLong: objectLong)
            } label: {
                Img.baselineDirectionsWhite36.swiftUIImage
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .padding(.top, 40)
            
            Button {
                shareLink(objectId: objectId)
            } label: {
                Img.baselineShareWhite36.swiftUIImage
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            
            Spacer()
            
            Button {
                self.isFullScreenImageViewPresented = true
            } label: {
                Img.baselineCollectionsWhite36.swiftUIImage
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .padding(.vertical)
    }
    
    // MARK: Opens map and navigates to the object
    func openMap(objectLat: Double, objectLong: Double) {
        guard let url = URL(string:"http://maps.apple.com/?daddr=\(objectLat),\(objectLong)") else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: Shares a link to the object
    func shareLink(objectId: Int) {
        let url = URL(string: "https://vakufi.me/objekat/\(objectId)")
        let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
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
            .scaledToFill()
    }
}
