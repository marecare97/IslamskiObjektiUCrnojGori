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
    @State var selectedObjectDetails: ObjectDetails?
    @State var isObjectDetailsViewPresented = false
    @State private var isEditing = false
    @State private var isSearchNavBarHidden = true
    @State var searchTerm: String = ""
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack(alignment: .top, content: {
            customNavBar
                .zIndex(1)
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                contentView
                    .ignoresSafeArea()
                if !showLeftSideMenu {
                    Img.list.swiftUIImage
                        .resizable()
                        .frame(width: 50, height: 80)
                        .onTapGesture {
                            withAnimation {
                                showLeftSideMenu = true
                            }
                        }
                }
                if !showLeftSideMenu && !showRightSideMenu {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Img.bgDetails.swiftUIImage
                                .resizable()
                                .frame(width: 250, height: 80)
                            
                            
                            VStack {
                                Button(action: {
                                    showRightSideMenu = true
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 50, height: 50)
                                        Img.iconFilter.swiftUIImage
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                Button(action: {}) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 50, height: 50)
                                        Img.iconGallery.swiftUIImage
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                            }
                            .padding(.bottom, 50)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
            
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .onAppear(perform: viewModel.fetchAllObjects)
    }
    
    var customNavBar: some View {
        HStack {
            ZStack {
                Img.toolbar.swiftUIImage
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                searchNavBar
                    .isHidden(isSearchNavBarHidden)
                
                defaultNavBar
                    .isHidden(!isSearchNavBarHidden)
            }
        }
        .background(Color.clear)
        .frame(maxHeight: 50)
    }
    
    
    var defaultNavBar: some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.showLeftSideMenu.toggle()
                }
            }, label: {
                Image(systemSymbol: .line3Horizontal)
                    .foregroundColor(.white)
                    .imageScale(.large)
            })
            
            Text((Str.objects + " (\(viewModel.allObjects.count))"))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    isSearchNavBarHidden.toggle()
                }
            }, label: {
                Image(systemSymbol: .magnifyingglass)
                    .foregroundColor(.white)
                    .imageScale(.large)
            })
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
    
    var searchNavBar: some View {
        HStack {
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.isSearchNavBarHidden = true
                    self.searchTerm = ""
                    
                }) {
                    Image(systemSymbol: .arrowBackward)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
            
            TextField(Str.objectName, text: $searchTerm)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.clear))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
        }
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
                
                if self.showRightSideMenu {
                    HStack {
                        Spacer()
                        RightSideMenu(objectsDetails: $viewModel.allObjects)
                            .frame(width: geometry.size.width / 1.3)
                            .transition(.move(edge: .trailing))
                    }
                }
            }
            .gesture(
                DragGesture().onEnded {
                    if $0.translation.width < -100 || $0.translation.width < 100{
                        withAnimation {
                            self.showLeftSideMenu = false
                            self.showRightSideMenu = false
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
