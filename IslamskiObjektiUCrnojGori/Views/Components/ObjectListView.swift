//
//  ObjectListView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 13.4.23..
//

import SwiftUI
import CoreLocation

struct ObjectListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var locationService = CompositionRoot.shared.locationService
    @State var allObjects: [ObjectDetails]
    
    var body: some View {
        Group {
            ZStack(alignment: .top) {
                List {
                    ForEach(sortedObjectsByDistance()) { object in
                        ObjectItem(details: object)
                            .padding()
                    }
                }
                customNavBar
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            locationService.startUpdatingLocation()
            locationService.publisher
                .sink { location in
                    print("CURRENT DIRECTION UPDATE ==> \(location)")
                }
                .store(in: &locationService.cancellables)
        }
        .onDisappear {
            locationService.stopUpdatingLocation()
        }
    }
    
    var customNavBar: some View {
        HStack {
            ZStack {
                Img.toolbar.swiftUIImage
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                defaultNavBar
            }
        }
        .background(Color.clear)
        .frame(maxHeight: 50)
    }
    
    var defaultNavBar: some View {
        HStack {
            Button(action: {
                withAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Img.back.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            Text(TK.HomePageView.objects)
                .foregroundColor(.white)
                .padding(.leading)
            
            Spacer()
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
    
    func sortedObjectsByDistance() -> [ObjectDetails] {
        guard let currentLocation = locationService.lastKnownLocation else { return allObjects }
        let currentCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        let sortedObjects = allObjects.sorted { (object1, object2) -> Bool in
            let location1 = CLLocation(latitude: object1.latitude, longitude: object1.longitude)
            let location2 = CLLocation(latitude: object2.latitude, longitude: object2.longitude)
            let distance1 = currentCLLocation.distance(from: location1)
            let distance2 = currentCLLocation.distance(from: location2)
            return distance1 < distance2
        }
        return sortedObjects
    }
}

struct ObjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectListView(allObjects: [])
    }
}
