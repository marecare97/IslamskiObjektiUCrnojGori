//
//  LocationService.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 14.3.23..
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let locationSubject = CurrentValueSubject<CLLocation, Never>(CLLocation())
    private let authorizationStatusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    var cancellables = Set<AnyCancellable>()
    
    @Published var heading: Double = 0.0
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    var publisher: AnyPublisher<CLLocation, Never> {
        locationSubject
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main) // Limit the rate of updates to 1 per second
            .eraseToAnyPublisher()
    }
    
    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.distanceFilter = 1
        locationManager.headingFilter = 1
        locationManager.requestAlwaysAuthorization()
        
        locationManager.publisher(for: \.authorizationStatus)
            .sink { [weak self] status in
                self?.authorizationStatusSubject.send(status)
            }
            .store(in: &cancellables)
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastKnownLocation = location.coordinate
        locationSubject.send(location)
    }
    
    // Implement background location updates by requesting appropriate permissions and configuring the locationManager
    func enableBackgroundUpdates() {
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func disableBackgroundUpdates() {
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading.trueHeading
        }
    }
}
