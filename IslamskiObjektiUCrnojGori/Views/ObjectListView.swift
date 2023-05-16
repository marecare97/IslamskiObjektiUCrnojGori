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
    @State var isObjectDetailsViewPresented = false
    @State var selectedObjectDetails: ObjectDetails?
    
    init(sortedObjects: [ObjectDetails], selectedObjectDetails: ObjectDetails? = nil) {
        self.sortedObjects = sortedObjects
        self.selectedObjectDetails = selectedObjectDetails
    }
    
    var body: some View {
        Group {
            contentView
        }
        .navigationBarBackButtonHidden()
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
                ForEach(sortedObjects, id: \.id) { object in
                    LazyVStack {
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
        ObjectListView(sortedObjects: [])
    }
}
