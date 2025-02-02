//
//  QiblaView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 18.3.23..
//

import SwiftUI
import CoreLocation

struct QiblaView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var locationService = CompositionRoot.shared.locationService
    @StateObject var rotationManager = PhoneRotationManager()
    @State private var qiblaDirection: Double = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            CustomNavBar(navBarTitle: TK.Kibla.title)
            VStack {
                Spacer()
                
                Img.qiblaCompass.swiftUIImage
                    .resizable()
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(qiblaDirection - locationService.heading))
                    .ignoresSafeArea()
                    .onAppear {
                        locationService.startUpdatingLocation()
                        locationService.publisher
                            .sink { location in
                                // Calculate direction of Qibla from user's location
                                let kaabaLocation = CLLocation(latitude: 21.4225, longitude: 39.8262) // Coordinates of Kaaba
                                let qiblaDirection = location.coordinate.direction(to: kaabaLocation.coordinate)
//                                print("QIBLA DIRECTION ==> \(qiblaDirection)")
                                withAnimation {
                                    self.qiblaDirection = qiblaDirection
                                }
                            }
                            .store(in: &locationService.cancellables)
                    }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct QiblaView_Previews: PreviewProvider {
    static var previews: some View {
        QiblaView()
    }
}
