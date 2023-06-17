//
//  UsefulLinksSideMenuView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 6.3.23..
//

import SwiftUI
import Combine

struct UsefulLinksSideMenuView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            CustomNavBar(navBarTitle: TK.LeftSideMenu.usefulLinks)
            contentView
        }
        .navigationBarBackButtonHidden()
    }
    
    var contentView: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.links, id: \.id) { link in
                        NavigationLink(
                            destination: WebView(url: URL(string: link.url)!)) {
                                HStack {
                                    Text(link.title)
                                    
                                    Spacer()
                                    
                                    Image(systemSymbol: .chevronRight)
                                }
                                .foregroundColor(.black)
                                .bold()
                            }
                        
                        if link != viewModel.links.last {
                            Divider()
                        }
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .edgesIgnoringSafeArea(.horizontal)
            }
        }
    }
}

struct UsefulLinksSideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        UsefulLinksSideMenuView()
    }
}

extension UsefulLinksSideMenuView {
    final class ViewModel: ObservableObject {
        private var cancellable: AnyCancellable? = nil
        @Published var isLoading = false
        @Published var links = [Links.Link]()
        
        init() {
            fetchLinks()
        }
        
        func fetchLinks() {
            isLoading = true
            cancellable = CompositionRoot.shared.linksProvider.fetchLinks()
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { links in
                    self.links = links.message
                    self.isLoading  = false
                }
                )
        }
    }
}


