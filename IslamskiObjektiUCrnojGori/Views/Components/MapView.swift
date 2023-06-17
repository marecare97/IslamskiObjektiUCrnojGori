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
    @Binding var filteredObjects: [ObjectDetails]
    let selectedObject: ObjectDetails? // FIXME: - crash
    @Binding var isChangeMapStyleButtonTapped: Bool
    let didTapOnObject: (ObjectDetails) -> Void
    
    init(
        allObjects: Binding<[ObjectDetails]>,
        filteredObjects: Binding<[ObjectDetails]>,
        selectedObject: ObjectDetails?,
        isChangeMapStyleButtonTapped: Binding<Bool>,
        didTapOnObject: @escaping (ObjectDetails) -> Void
    ) {
        self._allObjects = allObjects
        self._filteredObjects = filteredObjects
        self.selectedObject = selectedObject
        self._isChangeMapStyleButtonTapped = isChangeMapStyleButtonTapped
        self.didTapOnObject = didTapOnObject
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(didTapOnObject: didTapOnObject, isChangeMapStyleButtonTapped: $isChangeMapStyleButtonTapped)
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        uiViewController.setPins(for: allObjects)
        uiViewController.setPins(for: filteredObjects)
        if let selectedObject {
            uiViewController.setPin(for: selectedObject)
        }
        uiViewController.updateMapStyle(isSatellite: isChangeMapStyleButtonTapped)
    }
}

class MapViewController: UIViewController  {
    internal var mapView: MapView!
    private var pointAnnotationManager: PointAnnotationManager!
    private var allObjects = [ObjectDetails]()
    private var filteredObjects = [ObjectDetails]()
    let didTapOnObject: (ObjectDetails) -> Void
    @Binding var isChangeMapStyleButtonTapped: Bool
    
    init(
        didTapOnObject: @escaping (ObjectDetails) -> Void,
        isChangeMapStyleButtonTapped: Binding<Bool>
    ) {
        self.didTapOnObject = didTapOnObject
        self._isChangeMapStyleButtonTapped = isChangeMapStyleButtonTapped
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiYm96aWRhcnMyNyIsImEiOiJjazh6eGM0MTUwODNrM25uNDEzeTN0bGNxIn0.ruHpEdNSJu5NnmxEXmvYFg")
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 42.7087, longitude: 19.3744), zoom: 4.5)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions, styleURI: isChangeMapStyleButtonTapped ? .satellite : .light)
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
    
    //    func setPins(for objects: [ObjectDetails]) {
    //        if !objects.isEmpty {
    //            self.allObjects = objects
    //            let annotations = objects.map {
    //                var point = PointAnnotation(
    //                    coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
    //                )
    //                point.image = .init(image: UIImage(systemSymbol: .pinFill), name: "pin")
    //                point.iconAnchor = .bottom
    //                return point
    //            }
    //
    //            pointAnnotationManager.annotations = annotations
    //            mapView.layoutSubviews()
    //        }
    //    }
    
    func setPins(for objects: [ObjectDetails]) {
        if !objects.isEmpty {
            self.allObjects = objects
            let annotations = objects.map { object in
                var point = PointAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: object.latitude, longitude: object.longitude)
                )
                switch String(object.objType.icon) { // We get Substring from backend, converting to String here
                case "mosque":
                    point.image = .init(image: Img.mosque.image, name: "mosque")
                case "locality":
                    point.image = .init(image: Img.locality.image, name: "locality")
                case "institution":
                    point.image = .init(image: Img.institution.image, name: "institution")
                case "turbe":
                    point.image = .init(image: Img.turbe.image, name: "turbe")
                case "masjid":
                    point.image = .init(image: Img.masjid.image, name: "masjid")
                default:
                    point.image = .init(image: UIImage(systemSymbol: .pinFill), name: "pin")
                }
                point.iconSize = 0.3 // Set pin size
                point.iconAnchor = .bottom
                return point
            }
            pointAnnotationManager.annotations = annotations
            mapView.layoutSubviews()
        }
    }
    
    func setPin(for object: ObjectDetails) {
        var point = PointAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: object.latitude, longitude: object.longitude)
        )
        switch String(object.objType.icon) { // We get Substring from backend, converting to String here
        case "mosque":
            point.image = .init(image: Img.mosque.image, name: "mosque")
        case "locality":
            point.image = .init(image: Img.locality.image, name: "locality")
        case "institution":
            point.image = .init(image: Img.institution.image, name: "institution")
        case "turbe":
            point.image = .init(image: Img.turbe.image, name: "turbe")
        case "masjid":
            point.image = .init(image: Img.masjid.image, name: "masjid")
        default:
            point.image = .init(image: UIImage(systemSymbol: .pinFill), name: "pin")
        }
        point.iconSize = 0.3 // Set pin size
        point.iconAnchor = .bottom
        pointAnnotationManager.annotations = [point]
        mapView.layoutSubviews()
    }
    
    func updateMapStyle(isSatellite: Bool) {
        mapView.mapboxMap.style.uri = isSatellite ? .satelliteStreets : .streets
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
        mapView.camera.fly(to: CameraOptions(center: newLocation.coordinate, zoom: 7.0), duration: 3.0)
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
