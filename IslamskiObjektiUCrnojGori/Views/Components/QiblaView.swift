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
    @State private var qiblaDirection: Double = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            customNavBar
            VStack {
                Spacer()
                
                Img.qiblaCompass.swiftUIImage
                    .resizable()
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(qiblaDirection))
                    .ignoresSafeArea()
                    .onAppear {
                        locationService.startUpdatingLocation()
                        locationService.publisher
                            .sink {location in
                                // Calculate direction of Qibla from user's location
                                let kaabaLocation = CLLocation(latitude: 21.4225, longitude: 39.8262) // Coordinates of Kaaba
                                let qiblaDirection = location.coordinate.direction(to: kaabaLocation.coordinate)
                                print("QIBLA DIRECTION ==> \(qiblaDirection)")
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
            
            Text(TK.Kibla.title)
                .foregroundColor(.white)
                .padding(.leading)
            
            Spacer()
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}

struct QiblaView_Previews: PreviewProvider {
    static var previews: some View {
        QiblaView()
    }
}
