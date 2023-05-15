//
//  ObjectListView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 13.4.23..
//

import SwiftUI
import CoreLocation
import Combine

struct ObjectListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isObjectDetailsViewPresented = false
    @State var selectedObjectDetails: ObjectDetails?
    
    @StateObject var viewModel: ViewModel
    
    init() {
        let locationService = LocationService()
        self._viewModel = StateObject(wrappedValue: ViewModel(locationService: locationService))
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .initial:
                ProgressView()
            case .loading:
                ProgressView()
            case .finished:
                contentView
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.fetchAllObjects()
        }
    }
    
    var contentView: some View {
        VStack {
            if let objDetails = selectedObjectDetails {
                NavigationLink(
                    destination: ObjectDetailsView(details: objDetails),
                    isActive: $isObjectDetailsViewPresented,
                    label: {}
                )
                .isHidden(true)
            }
            CustomNavBar(navBarTitle: TK.HomePageView.objects)
            ScrollView {
                ForEach(viewModel.filteredObjects, id: \.id) { object in
                    VStack {
                        ObjectItem(details: object)
                            .padding()
                            .onTapGesture {
                                selectedObjectDetails = object
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                    isObjectDetailsViewPresented = true
                                }
                            }
                        Divider()
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
    }
}

struct ObjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectListView()
    }
}

extension ObjectListView {
    final class ViewModel: ObservableObject {
        @ObservedObject var locationService: LocationService
        
        private var cancellable: AnyCancellable?
        @Published var allObjects = [ObjectDetails]()
        @Published var filteredObjects: [ObjectDetails] = []
        @Published var state: ViewState = .initial
        
        enum ViewState {
            case initial
            case loading
            case finished
        }
        
        init(locationService: LocationService) {
            self.locationService = locationService
        }
        
        func fetchAllObjects() {
            cancellable = CompositionRoot.shared.objectsProvider.fetchAllObjects()
                .sink { completion in
                    print(completion)
                } receiveValue: { allObjects in
                    self.allObjects = allObjects.message
                    self.sortedObjectsByDistance(objects: allObjects.message)
                    self.state = .finished
                }
        }
        
        func sortedObjectsByDistance(objects: [ObjectDetails]) {
            if let currentLocation = locationService.lastKnownLocation {
                let currentCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                
                let sortedObjects = objects.sorted { (object1, object2) -> Bool in
                    let location1 = CLLocation(latitude: object1.latitude, longitude: object1.longitude)
                    let location2 = CLLocation(latitude: object2.latitude, longitude: object2.longitude)
                    let distance1 = currentCLLocation.distance(from: location1)
                    let distance2 = currentCLLocation.distance(from: location2)
                    return distance1 < distance2
                }
                filteredObjects = sortedObjects
            }
        }
    }
}
