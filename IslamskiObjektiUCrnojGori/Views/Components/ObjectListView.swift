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
    
    var body: some View {
        List {
            ForEach(sortedObjectsByDistance()) { object in
                ObjectItem(details: object)
                    .padding()
            }
        }
    }
    
    func sortedObjectsByDistance() -> [ObjectDetails] {
        let locationManager = CLLocationManager()
        guard let currentLocation = locationManager.location else { return allObjects }
        
        let sortedObjects = allObjects.sorted { (object1, object2) -> Bool in
            let location1 = CLLocation(latitude: object1.latitude, longitude: object1.longitude)
            let location2 = CLLocation(latitude: object2.latitude, longitude: object2.longitude)
            let distance1 = currentLocation.distance(from: location1)
            let distance2 = currentLocation.distance(from: location2)
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
