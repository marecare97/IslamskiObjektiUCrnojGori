//
//  MapBoxDetailView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 20.5.23..
//

import Foundation
import SwiftUI
import MapboxMaps

struct MapBoxDetailView: UIViewControllerRepresentable {
    let objectDetails: ObjectDetails
    @Binding var isChangeMapStyleButtonTapped: Bool
    
    init(
        objectDetails: ObjectDetails,
        isChangeMapStyleButtonTapped: Binding<Bool>
    ) {
        self.objectDetails = objectDetails
        self._isChangeMapStyleButtonTapped = isChangeMapStyleButtonTapped
    }

    func makeUIViewController(context: Context) -> MapBoxDetailViewController {
        let viewController = MapBoxDetailViewController(selectedDetails: objectDetails, isChangeMapStyleButtonTapped: $isChangeMapStyleButtonTapped)
        viewController.isMapInitialized = false
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MapBoxDetailViewController, context: Context) {
        uiViewController.selectedDetails = objectDetails
        if !uiViewController.isMapInitialized {
            uiViewController.initializeMap()
            uiViewController.isMapInitialized = true
        }
        uiViewController.updateMapStyle(isSatellite: isChangeMapStyleButtonTapped)
    }
}

final class MapBoxDetailViewController: UIViewController {
    internal var mapView: MapView!
    var selectedDetails: ObjectDetails
    private var pointAnnotationManager: PointAnnotationManager!
    @Binding var isChangeMapStyleButtonTapped: Bool
    var isMapInitialized = false
    
    init(
        selectedDetails: ObjectDetails,
        isChangeMapStyleButtonTapped: Binding<Bool>
    ) {
        self.selectedDetails = selectedDetails
        self._isChangeMapStyleButtonTapped = isChangeMapStyleButtonTapped
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiYm96aWRhcnMyNyIsImEiOiJjazh6eGM0MTUwODNrM25uNDEzeTN0bGNxIn0.ruHpEdNSJu5NnmxEXmvYFg")
        
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: selectedDetails.latitude, longitude: selectedDetails.longitude), zoom: 15)
        
        let myMapInitOptions = MapInitOptions(
            resourceOptions: myResourceOptions,
            cameraOptions: cameraOptions,
            styleURI: isChangeMapStyleButtonTapped ? .satellite : .light
        )
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(mapView)
        
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        
        setPin()
    }
    
    func setPin() {
        var point = PointAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: selectedDetails.latitude, longitude: selectedDetails.longitude)
        )
        switch String(selectedDetails.objType.icon) { // We get Substring from backend, converting to String here
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
        guard let mapView = mapView else {
            return // Exit early if mapView is nil
        }
        mapView.mapboxMap.style.uri = isSatellite ? .satelliteStreets : .streets
    }
}


