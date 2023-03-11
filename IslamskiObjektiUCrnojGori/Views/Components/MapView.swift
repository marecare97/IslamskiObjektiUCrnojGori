//
//  MapView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23..
//

import SwiftUI
import MapboxMaps
import CoreLocation

struct MapBoxMapView: UIViewControllerRepresentable {
    @Binding var allObjects: [ObjectDetails]
    let didTapOnObject: (ObjectDetails) -> Void

    init(
        allObjects: Binding<[ObjectDetails]>,
        didTapOnObject: @escaping (ObjectDetails) -> Void
    ) {
        self._allObjects = allObjects
        self.didTapOnObject = didTapOnObject
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(didTapOnObject: didTapOnObject)
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        uiViewController.setPins(for: allObjects)
    }
}

class MapViewController: UIViewController  {
    internal var mapView: MapView!
    private var pointAnnotationManager: PointAnnotationManager!
    private var allObjects = [ObjectDetails]()
    let didTapOnObject: (ObjectDetails) -> Void
    
    init(didTapOnObject: @escaping (ObjectDetails) -> Void) {
        self.didTapOnObject = didTapOnObject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiYm96aWRhcnMyNyIsImEiOiJjazh6eGM0MTUwODNrM25uNDEzeTN0bGNxIn0.ruHpEdNSJu5NnmxEXmvYFg")
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 40.83647410051574, longitude: 14.30582273457794), zoom: 4.5)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions, styleURI: StyleURI.light)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        mapView.location.delegate = self
        mapView.location.options.activityType = .other
        mapView.location.options.puckType = .puck2D()
        mapView.location.locationProvider.startUpdatingLocation()
        
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapClick)))

        mapView.mapboxMap.onNext(.mapLoaded) { [weak self] _ in
            guard let self = self, let latestLocation = self.mapView.location.latestLocation else { return }
            self.locationUpdate(newLocation: latestLocation)
        }
    }

    func setPins(for objects: [ObjectDetails]) {
        if !objects.isEmpty {
            self.allObjects = objects
            let annotations = objects.map {
                var point = PointAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                )
                point.image = .init(image: UIImage(systemSymbol: .pinFill), name: "pin")
                point.iconAnchor = .bottom
                return point
            }

            pointAnnotationManager.annotations = annotations
            mapView.layoutSubviews()
        }
    }
    
    
    @objc private func onMapClick(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.mapboxMap.coordinate(for: point)
        let sortedObjects = allObjects.sorted {
            CLLocation.distance(from: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), to: coordinate) < CLLocation.distance(from: CLLocationCoordinate2D(latitude: $1.latitude, longitude: $1.longitude), to: coordinate)
        }
        
        if let first = sortedObjects.first, CLLocation.distance(from: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude), to: coordinate) < 500 {
            didTapOnObject(first)
        }
    }
}


extension MapViewController: LocationPermissionsDelegate, LocationConsumer {
    func locationUpdate(newLocation: MapboxMaps.Location) {
        mapView.camera.fly(to: CameraOptions(center: newLocation.coordinate, zoom: 10.0), duration: 5.0)
    }
}

extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
