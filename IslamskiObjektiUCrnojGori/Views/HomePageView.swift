//
//  HomePageView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23.§.
//

import SwiftUI
import MapboxMaps
import Combine

struct HomePageView: View {
    typealias Str = TK.HomePageView
    @State var showLeftSideMenu = false
    @State var showRightSideMenu = false
    @ObservedObject var viewModel = ViewModel()
    @State var selectedObjectDetails: ObjectDetails?
    @State var isObjectDetailsViewPresented = false
    var body: some View {
        contentView
            .onAppear(perform: viewModel.fetchAllObjects)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Str.objects + " (\(viewModel.allObjects.count))")
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showLeftSideMenu.toggle()
                    }
                }, label: {
                    Image(systemSymbol: .line3Horizontal)
                        .imageScale(.large)
                })
            ),
                                trailing: (
                                    Button(action: {
                                        
                                    }, label: {
                                        Image(systemSymbol: .magnifyingglass)
                                            .imageScale(.large)
                                    })
                                ))
    }
    
    var contentView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if let selectedObjectDetails {
                    NavigationLink(
                        destination: ObjectDetailsView(details: selectedObjectDetails),
                        isActive: $isObjectDetailsViewPresented) {
                            
                        }
                        .frame(width: 0, height: 0)
                        .hidden()
                }
                MapBoxMapView(
                    allObjects: $viewModel.allObjects,
                    didTapOnObject: { details in
                        selectedObjectDetails = details
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isObjectDetailsViewPresented = true
                        }
                    }
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .disabled(self.showLeftSideMenu ? true : false)
                .blur(
                    radius: showLeftSideMenu ? 1.0 : 0.0
                )
                
                if self.showLeftSideMenu {
                    LeftSideMenuView()
                        .frame(width: geometry.size.width / 1.5)
                        .transition(.move(edge: .leading ))
                }
            }
            .gesture(
                DragGesture().onEnded {
                    if $0.translation.width < -100 {
                        withAnimation {
                            self.showLeftSideMenu = false
                        }
                    }
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

extension HomePageView {
    final class ViewModel: ObservableObject {
        private var cancellable: AnyCancellable?
        @Published var allObjects = [ObjectDetails]()
        
        func fetchAllObjects() {
            cancellable = CompositionRoot.shared.objectsProvider.fetchAllObjects()
                .sink { completion in
                    print(completion)
                } receiveValue: { allObjects in
                    self.allObjects = allObjects.message
                }
        }
    }
}
