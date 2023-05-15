//
//  ObjectItem.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 25.4.23..
//

import SwiftUI
import Combine
import SDWebImageSwiftUI
import CoreLocation

struct ObjectItem: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let details: ObjectDetails?
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        HStack {
            if let objDetails = details {
                VStack(alignment: .leading) {
                    HStack {
                        viewModel.getObjectIcon(objName: objDetails.objType.icon)
                            .resizable()
                            .frame(width: 20, height: 32)
                        
                        Text(objDetails.town.name + " " + "(\(String(describing: viewModel.distanceBetweenObjectAndUser)) km)")
                            .font(RFT.bold.swiftUIFont(size: 13))
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text(objDetails.name)
                            .font(RFT.bold.swiftUIFont(size: 15))
                            .lineLimit(2)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                WebImage(url: URL(string: objDetails.image))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.green, lineWidth: 2)
                    )
            }
            else {
                Text("No object details available")
            }
        }
        .onAppear {
            viewModel.getDistance(objectLatitude: details?.latitude, objectLogitude: details?.longitude)
        }
    }
}

struct ObjectItem_Previews: PreviewProvider {
    static var previews: some View {
        ObjectItem(details: nil)
    }
}

extension ObjectItem {
    final class ViewModel: ObservableObject {
        private var cancellable: AnyCancellable?
        @Published var distanceBetweenObjectAndUser = ""
        
        func getDistance(objectLatitude: Double?, objectLogitude: Double?) {
            let locationManager = CLLocationManager()
            guard let currentLocation = locationManager.location else { return }
            guard let objectLat = objectLatitude else { return }
            guard let objectLong = objectLogitude else { return }
            
            let currentCoordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let targetCoordinate = CLLocationCoordinate2D(latitude: objectLat, longitude: objectLong)
            
            cancellable = CurrentValueSubject<Void, Never>(()).sink { [weak self] _ in
                let distanceInMeters = CLLocation.distance(from: currentCoordinate, to: targetCoordinate)
                let distanceInKilometers = distanceInMeters/1000
                let formattedKilometers = String(format: "%.3f", distanceInKilometers)
                print("DISTANCE =====> \(formattedKilometers)")
                self?.distanceBetweenObjectAndUser = formattedKilometers
            }
        }
        
        func getObjectIcon(objName: String) -> Image {
            let iconMap: [String: Image] = [
                "mosque": Img.mosque.swiftUIImage,
                "locality": Img.locality.swiftUIImage,
                "institution": Img.institution.swiftUIImage,
                "turbe": Img.turbe.swiftUIImage,
                "masjid": Img.masjid.swiftUIImage
            ]
            return iconMap[objName] ?? Img.mosque.swiftUIImage
        }
    }
}
