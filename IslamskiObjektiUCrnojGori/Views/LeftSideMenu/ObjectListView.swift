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
    
    var sortedObjects: [ObjectDetails]
    var filteredObjects: [ObjectDetails]
    
    @State var isObjectDetailsViewPresented = false
    @State var selectedObjectDetails: ObjectDetails?
    @State private var navigationDestination: NavigationDestination? = nil
    var isFiltering = false
    
    enum NavigationDestination {
        case objectDetailsView
    }
    
    init(
        sortedObjects: [ObjectDetails],
        filteredObjects: [ObjectDetails],
        selectedObjectDetails: ObjectDetails? = nil,
        isFiltering: Bool
    ) {
        self.sortedObjects = sortedObjects
        self.filteredObjects = filteredObjects
        self.selectedObjectDetails = selectedObjectDetails
        self.isFiltering = isFiltering
    }
    
    var body: some View {
        Group {
            navigationLinks
            contentView
        }
        .navigationBarBackButtonHidden()
    }
    
    var contentView: some View {
        ScrollView {
            ForEach(isFiltering ? filteredObjects : sortedObjects, id: \.id) { object in
                LazyVStack {
                    ObjectItem(details: object)
                        .padding()
                        .onTapGesture {
                            selectedObjectDetails = object
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                navigationDestination = .objectDetailsView
                            }
                        }
                    Divider()
                }
                .padding(.horizontal, 30)
            }
        }
        .padding(.top, 50)
    }
    
    // MARK: -- Navigation
    var navigationLinks: some View {
        VStack {
            if let objDetails = selectedObjectDetails {
                NavigationLink(
                    destination: ObjectDetailsView(details: objDetails),
                    tag: NavigationDestination.objectDetailsView,
                    selection: $navigationDestination,
                    label: { }
                )
            }
        }
        .hidden()
        .frame(width: 0, height: 0)
    }
}

struct ObjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectListView(sortedObjects: [], filteredObjects: [], isFiltering: false)
    }
}
