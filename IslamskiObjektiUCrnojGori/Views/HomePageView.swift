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
    
    @State var isObjectsListContentViewPresented = false
    @State var isObjectDetailsPreviewViewPresented = false
    @State var isObjectDetailsViewPresented = false
    @State private var isLoading = true
    
    @State private var isEditing = false
    @State private var isSearchNavBarHidden = true
    @State var searchTerm: String = ""
    
    @State var isChangeMapStyleButtonTapped = false
    @State var nextPrayerDate: Date? = nil
    @State var isWidgetPresented: Bool = UserDefaults.standard.bool(forKey: "islamskiObjekti.isWidgetPresented")
    
    @StateObject var viewModel = ViewModel()
    
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .initial:
                LottieAnimatingView(animation: .map_loader)
            case .loading:
                LottieAnimatingView(animation: .map_loader)
            case .finished:
                groupedView
                    .onAppear {
                        isWidgetPresented = UserDefaults.standard.bool(forKey: "islamskiObjekti.isWidgetPresented")
                        nextPrayerDate =  CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime() ?? CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime(forToday: false)
                    }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
    
    var groupedView: some View {
        ZStack(alignment: .top, content: {
            customNavBar
                .zIndex(1)
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                if isObjectsListContentViewPresented {
                    objectsListContentView
                } else {
                    mapBoxContentView
                        .ignoresSafeArea()
                }
                
                objectDetailsPreview
                    .isHidden(!showLeftSideMenu ? false : true)
                    .isHidden(!showRightSideMenu ? false : true)
                    .isHidden(!isObjectsListContentViewPresented ? false : true)
                    .isHidden(didTapOnObject ? false : true)
                    .animation(.easeOut)
                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                
                // MARK: Left side menu button
                if !showLeftSideMenu && !showRightSideMenu {
                    VStack {
                        
                        Spacer()
                        
                        let leftIconToShow = isObjectsListContentViewPresented ? Img.map.swiftUIImage : Img.list.swiftUIImage
                        
                        leftIconToShow
                            .resizable()
                            .frame(width: 50, height: 80)
                            .onTapGesture {
                                withAnimation {
                                    isObjectsListContentViewPresented.toggle()
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
                                    
                                    let rightFilterIconToShow = isObjectsListContentViewPresented ? Img.filterMajorMonotone.swiftUIImage :  Img.iconFilter.swiftUIImage
                                    
                                    rightFilterIconToShow
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            
                            if !isObjectsListContentViewPresented {
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
                        }
                        .padding(.bottom, 50)
                    }
                    .padding(.trailing)
                }
                
                // MARK: Bottom center namaz view
                if !showLeftSideMenu && !showRightSideMenu && isWidgetPresented && !isObjectsListContentViewPresented {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            ZStack {
                                Img.bgDetails.swiftUIImage
                                    .resizable()
                                    .frame(width: 250, height: 80)
                                
                                VStack {
                                    Text(Str.nextNamaz)
                                        .font(RFT.medium.swiftUIFont(size: 15))
                                        .foregroundColor(.gray)
                                    CountdownTimerView(targetDate: $viewModel.nextPrayerDate)
                                }
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
    }
    
    // MARK: Custom NavBar
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
    
    // MARK: Default NavBar
    var defaultNavBar: some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.showLeftSideMenu.toggle()
                }
            }, label: {
                Image(systemSymbol: showLeftSideMenu ? .arrowBackward : .line3Horizontal)
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .rotationEffect(Angle.degrees(showLeftSideMenu ? 360 : 0))
            })
            
            Text((Str.objects + " (\(viewModel.filteredObjects.count == 0 ? viewModel.allObjects.count : viewModel.filteredObjects.count))"))
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
    
    // MARK: Search NavBar
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
    
    // MARK: Map Box Content View
    var mapBoxContentView: some View {
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
                    LeftSideMenuView(longitude: longitude, latitude: latitude, allObjects: $viewModel.allObjects, sortedObjects: $viewModel.sortedObjects, isObjectsListContentViewPresented: $isObjectsListContentViewPresented)
                        .frame(width: geometry.size.width / 1.5)
                        .transition(.move(edge: .leading))
                }
                
                if self.showRightSideMenu {
                    HStack {
                        
                        Spacer()
                        
                        RightSideMenu(selectedFromYear: $viewModel.selectedFromYear, selectedToYear: $viewModel.selectedToYear,selectedTowns: $viewModel.selectedTowns, selectedMajlises: $viewModel.selectedMajlises, selectedObjectTypes: $viewModel.selectedObjectTypes, objectDetails: viewModel.allObjects, isObjectsListContentViewPresented: $isObjectsListContentViewPresented)
                            .environmentObject(viewModel)
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
    
    // MARK: Objects List Content View
    var objectsListContentView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ObjectListView(sortedObjects: viewModel.sortedObjects, filteredObjects: viewModel.filteredObjects)
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
                    LeftSideMenuView(longitude: longitude, latitude: latitude, allObjects: $viewModel.allObjects, sortedObjects: $viewModel.sortedObjects, isObjectsListContentViewPresented: $isObjectsListContentViewPresented)
                        .frame(width: geometry.size.width / 1.5)
                        .transition(.move(edge: .leading))
                }
                
                if self.showRightSideMenu {
                    HStack {
                        
                        Spacer()
                        
                        RightSideMenu(selectedFromYear: $viewModel.selectedFromYear, selectedToYear: $viewModel.selectedToYear,selectedTowns: $viewModel.selectedTowns, selectedMajlises: $viewModel.selectedMajlises, selectedObjectTypes: $viewModel.selectedObjectTypes, objectDetails: viewModel.allObjects, isObjectsListContentViewPresented: $isObjectsListContentViewPresented)
                            .environmentObject(viewModel)
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
    
    // MARK: Object Details Preview
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
    
    // MARK: Functions
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
        HomePageView(latitude: .constant(0.0), longitude: .constant(0.0))
    }
}

extension HomePageView {
    final class ViewModel: ObservableObject {
        private var cancellable: AnyCancellable?
        
        @Published var allObjects = [ObjectDetails]()
        @Published var filteredObjects: [ObjectDetails] = []
        @Published var sortedObjects: [ObjectDetails] = []
        
        @Published var state: ViewState = .initial
        @Published var locationService = CompositionRoot.shared.locationService
        @Published var nextPrayerDate: Date
        
        @Published var selectedTowns: [Location] = []
        @Published var selectedMajlises: [Location] = []
        @Published var selectedObjectTypes: [ObjType] = []
        @Published var selectedFromYear: Int = YearOfBuild.yearFromDropdown.first ?? 0
        @Published var selectedToYear: Int = YearOfBuild.currentYear
        
        var hasCalledFetch = false
        
        enum ViewState {
            case initial
            case loading
            case finished
        }
        
        init() {
            nextPrayerDate =  CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime() ?? CompositionRoot.shared.prayerTimesProvider.getNextPrayerTime(forToday: false) ?? Date()
            // FIXME:
            locationService.startUpdatingLocation()
            locationService.publisher
                .sink { [weak self] location in
                    guard let self = self else { return }
                    self.fetchAndSortObjects(userLocation: location.coordinate)
                    //                    print("USER LOCATION ==> \(location.coordinate)")
                }
                .store(in: &locationService.cancellables)
        }
        
        func fetchAndSortObjects(userLocation: CLLocationCoordinate2D?) {
            guard !hasCalledFetch else { return }
            hasCalledFetch = true
            
            guard let currentLocation = userLocation else {
                // Handle the case when userLocation is nil
                return
            }
            
            let currentCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            CompositionRoot.shared.objectsProvider.fetchAllObjects()
                .sink { [weak self] completion in
                    guard self != nil else { return }
                    print(completion)
                } receiveValue: { [weak self] allObjects in
                    guard let self = self else { return }
                    //                    print("svi objekti", allObjects)
                    self.allObjects = allObjects.message
                    let sorted = self.allObjects.sorted { (object1, object2) -> Bool in
                        let location1 = CLLocation(latitude: object1.latitude, longitude: object1.longitude)
                        let location2 = CLLocation(latitude: object2.latitude, longitude: object2.longitude)
                        let distance1 = currentCLLocation.distance(from: location1)
                        let distance2 = currentCLLocation.distance(from: location2)
                        return distance1 < distance2
                    }
                    self.sortedObjects = sorted
                    self.state = .finished
                }
                .store(in: &locationService.cancellables)
        }
        
        // MARK: Objects filters
        func filterObjects(with searchTerm: String) {
            if searchTerm.isEmpty {
                filteredObjects = allObjects
            } else {
                filteredObjects = allObjects.filter { object in
                    object.name.lowercased().contains(searchTerm.lowercased())
                }
            }
        }
        
        func filterObjectsByTown(selectedTowns: [Location]) {
            if selectedTowns.isEmpty {
                filteredObjects = allObjects
            } else {
                filteredObjects = allObjects.filter { object in
                    selectedTowns.contains(object.town)
                }
            }
        }
        
        func filterObjectsByMajlises(selectedMajlises: [Location]) {
            if selectedMajlises.isEmpty {
                filteredObjects = allObjects
            } else {
                filteredObjects = allObjects.filter { object in
                    selectedMajlises.contains(object.majlis)
                }
            }
        }
        
        func filterObjectsByObjectTypes(selectedObjectTypes: [ObjType]) {
            if selectedObjectTypes.isEmpty {
                filteredObjects = allObjects
            } else {
                filteredObjects = allObjects.filter { object in
                    selectedObjectTypes.contains(object.objType)
                }
            }
        }
        
        func filterObjectsByYearBuilt(fromYear: Int, toYear: Int) {
            if fromYear == 0 && toYear == 0 {
                filteredObjects = allObjects
            } else {
                filteredObjects = allObjects.filter { object in
                    if let year = object.yearBuilt {
                        return year >= fromYear && year <= toYear
                    }
                    return false
                }
            }
        }
    }
}
