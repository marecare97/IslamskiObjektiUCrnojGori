//
//  AboutView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI
import Combine

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
            case .finished:
                ZStack(alignment: .top) {
                    VStack {
                        Spacer()
                        
                        ScrollView(showsIndicators: false) {
                            Text(viewModel.about ?? "")
                                .padding()
                                .padding(.top, 70)
                        }
                    }
                    CustomNavBar(navBarTitle: TK.About.title)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

extension AboutView {
    final class ViewModel: ObservableObject {
        @Published var state: State = .loading
        @Published var about: String? = nil
        private var cancellable: Cancellable?
        
        enum State {
            case loading
            case finished
        }
        
        init() {
            fetchAbout()
        }
        
        func fetchAbout() {
            state = .loading
            cancellable = CompositionRoot.shared.aboutProvider.fetchAbout()
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { about in
                    self.about = about.message.content
                    self.state = .finished
                })
        }
    }
}
