//
//  ObjectListView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 13.4.23..
//

import SwiftUI
import CoreLocation

struct ObjectListView: View {
    @State var allObjects: [ObjectDetails]
    @StateObject var locationService = CompositionRoot.shared.locationService
    
    var body: some View {
        List {
            ForEach(sortedObjectsByDistance()) { object in
                ObjectItem(details: object)
                    .padding()
            }
        }
        .onAppear {
            locationService.startUpdatingLocation()
            locationService.publisher
                .sink { location in
                    print("CURRENT DIRECTION UPDATE ==> \(location)")
                }
                .store(in: &locationService.cancellables)
        }
    }
    
    func sortedObjectsByDistance() -> [ObjectDetails] {
        guard let currentLocation = CompositionRoot.shared.locationService.lastKnownLocation else { return allObjects }
        print("user location", currentLocation)
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
