//
//  HomePageView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23.§.
//

import SwiftUI
import MapboxMaps
import Combine
import SDWebImageSwiftUI
import SFSafeSymbols

struct HomePageView: View {
    typealias Str = TK.HomePageView
    typealias S = TK.ObjectDetailsPreview
    
    @State var showLeftSideMenu = false
    @State var showRightSideMenu = false
    @State var selectedObjectDetails: ObjectDetails?
    @State private var didTapOnObject = false
    @State var isObjectDetailsPreviewViewPresented = false
    @State var isObjectDetailsViewPresented = false
    @State private var isEditing = false
    @State private var isSearchNavBarHidden = true
    @State var searchTerm: String = ""
    @State var isChangeMapStyleButtonTapped = false
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack(alignment: .top, content: {
            customNavBar
                .zIndex(1)
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                contentView
                    .ignoresSafeArea()
                
                objectDetailsPreview
                    .isHidden(!showLeftSideMenu ? false : true)
                    .isHidden(!showRightSideMenu ? false : true)
                    .isHidden(didTapOnObject ? false : true)
                    .animation(.easeOut)
                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                
                // MARK: Left side menu button
                if !showLeftSideMenu && !showRightSideMenu {
                    VStack {
                        
                        Spacer()
                        
                        Img.list.swiftUIImage
                            .resizable()
                            .frame(width: 50, height: 80)
                            .onTapGesture {
                                withAnimation {
                                    showLeftSideMenu = true
                                }
                            }
                        
                        Spacer()
                    }
                }
                
                // MARK: Bottom right buttons
                if !showLeftSideMenu && !showRightSideMenu {
                    HStack {
                        
                        Spacer()
                        
                        VStack {
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    self.showRightSideMenu.toggle()
                                }
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
                            Button(action: {
                                isChangeMapStyleButtonTapped.toggle()
                            }) {
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
                
                // MARK: Bottom center namaz view
                if !showLeftSideMenu && !showRightSideMenu {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            ZStack {
                                Img.bgDetails.swiftUIImage
                                    .resizable()
                                    .frame(width: 250, height: 80)
                                
                                Text(Str.nextNamaz)
                                    .font(RFT.medium.swiftUIFont(size: 15))
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                            }
                            
                            Spacer()
                            
                        }
                    }
                    .ignoresSafeArea()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
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
            
            Spacer()
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.isSearchNavBarHidden = true
                    self.searchTerm = ""
                    viewModel.filterObjects(with: "")
                }) {
                    Image(systemSymbol: .arrowBackward)
                        .foregroundColor(.black)
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
            
            TextField(Str.objectName, text: $searchTerm)
                .padding(7)
                .padding(.horizontal, 10)
                .background(Color(.clear))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .onChange(of: searchTerm) { value in
                    viewModel.filterObjects(with: value)
                }
        }
    }
    
    var contentView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                MapBoxMapView(
                    allObjects: $viewModel.allObjects,
                    filteredObjects: $viewModel.filteredObjects,
                    selectedObject: nil,
                    isChangeMapStyleButtonTapped: $isChangeMapStyleButtonTapped,
                    didTapOnObject: { details in
                        selectedObjectDetails = details
                        didTapOnObject = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isObjectDetailsPreviewViewPresented = true
                        }
                    }
                )
                .onTapGesture {
                    didTapOnObject = false
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .disabled(self.showLeftSideMenu ? true : false)
                .disabled(self.showRightSideMenu ? true : false)
                .blur(
                    radius: showLeftSideMenu ? 1.0 : 0.0
                )
                .blur(
                    radius: showRightSideMenu ? 1.0 : 0.0
                )
                
                if self.showLeftSideMenu {
                    LeftSideMenuView()
                        .frame(width: geometry.size.width / 1.5)
                        .transition(.move(edge: .leading))
                }
                
                if self.showRightSideMenu {
                    HStack {
                        
                        Spacer()
                        
                        RightSideMenu(objectsDetails: $viewModel.allObjects)
                            .frame(width: geometry.size.width / 1.5)
                            .transition(.move(edge: .trailing))
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        // scroll to the right and hide right side menu
                        if gesture.translation.width > 100 {
                            withAnimation {
                                self.showRightSideMenu = false
                            }
                            // scroll to the left and hide left side menu
                        } else if gesture.translation.width < -100 {
                            withAnimation {
                                self.showLeftSideMenu = false
                            }
                        }
                    }
            )
        }
    }
    
    var objectDetailsPreview: some View {
        VStack {
            
            Spacer()
            
            HStack {
                if let objDetails = selectedObjectDetails {
                    NavigationLink(
                        destination: ObjectDetailsView(details: objDetails),
                        isActive: $isObjectDetailsViewPresented,
                        label: {}
                    )
                    .frame(width: 0, height: 0)
                    .hidden()
                    
                    WebImage(url: URL(string: objDetails.image))
                        .resizable()
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.green, lineWidth: 2)
                        )
                        .frame(width: 70, height: 70)
                        .padding(.trailing)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(objDetails.name)
                            .font(RFT.bold.swiftUIFont(size: 18))
                            .lineLimit(1) // FIXME: -- sometimes text is too big
                            .foregroundColor(.white)
                        
                        Text(objDetails.objType.name)
                            .font(RFT.bold.swiftUIFont(size: 15))
                            .lineLimit(1)
                            .foregroundColor(.gray)
                        
                        HStack {
                            getObjectIcon(objName: objDetails.objType.icon)
                                .resizable()
                                .frame(width: 20, height: 30)
                            
                            Text(objDetails.town.name)
                                .font(RFT.bold.swiftUIFont(size: 15))
                                .lineLimit(1)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button {
                                isObjectDetailsViewPresented = true
                            } label: {
                                HStack(spacing: 5) {
                                    Text(S.detailed)
                                        .font(PFT.semiBold.swiftUIFont(size: 15))
                                    Image(systemSymbol: .chevronRight)
                                        .imageScale(.small)
                                }
                                .foregroundColor(.green)
                            }
                        }
                        .padding(.trailing)
                    }
                }  else {
                    Text("No object details available")
                }
            }
            .padding(.leading)
            .padding(.vertical)
        }
        .frame(height: 180)
        .background(.black)
    }
    
    private func getObjectIcon(objName: String) -> SwiftUI.Image {
        let iconMap: [String: SwiftUI.Image] = [
            "mosque": Img.mosque.swiftUIImage,
            "locality": Img.locality.swiftUIImage,
            "institution": Img.institution.swiftUIImage,
            "turbe": Img.turbe.swiftUIImage,
            "masjid": Img.masjid.swiftUIImage
        ]
        return iconMap[objName] ?? Img.mosque.swiftUIImage
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
        @Published var filteredObjects: [ObjectDetails] = []
        
        func fetchAllObjects() {
            cancellable = CompositionRoot.shared.objectsProvider.fetchAllObjects()
                .sink { completion in
                    print(completion)
                } receiveValue: { allObjects in
                    self.allObjects = allObjects.message
                }
        }
        
        func filterObjects(with searchTerm: String) {
            if searchTerm.isEmpty {
                filteredObjects = allObjects
            } else {
                filteredObjects = allObjects.filter { object in
                    object.name.lowercased().contains(searchTerm.lowercased())
                }
            }
        }
    }
}
