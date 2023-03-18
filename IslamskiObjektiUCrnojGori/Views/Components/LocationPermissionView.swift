//
//  LocationPermissionView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 14.3.23..
//

import SwiftUI
import UIKit
import Combine
import CoreLocation

struct LocationPermissionView: View {
    typealias Str = TK.AccessLocation
    @StateObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            SplashScreen()
                .onAppear(perform: locationViewModel.requestPermission)
        case .restricted:
            grantLocationView
        case .denied:
            grantLocationView
        case .authorizedAlways, .authorizedWhenInUse:
            HomePageView()
        @unknown default:
            grantLocationView
        }
    }
    
    var grantLocationView: some View {
        VStack {
            Spacer()
            
            Text(Str.message)
                .padding(.top)
                .lineLimit(0)
            Button(Str.buttonTitle) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.bordered)
            .padding(.vertical)
            .padding(.horizontal, 50)
            
            Spacer()
        }
    }
}

extension LocationPermissionView {
    final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var authorizationStatus: CLAuthorizationStatus
        
        private let locationManager: CLLocationManager
        
        override init() {
            locationManager = CLLocationManager()
            authorizationStatus = locationManager.authorizationStatus
            
            super.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
        
        func requestPermission() {
            locationManager.requestWhenInUseAuthorization()
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            authorizationStatus = manager.authorizationStatus
        }
    }
}

struct LocationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPermissionView()
    }
}
