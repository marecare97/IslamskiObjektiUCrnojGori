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

    func makeUIViewController(context: Context) -> MapBoxDetailViewController {
        MapBoxDetailViewController(selectedDetails: objectDetails, isChangeMapStyleButtonTapped: $isChangeMapStyleButtonTapped)
    }
    
    func updateUIViewController(_ uiViewController: MapBoxDetailViewController, context: Context) {
//        uiViewController.updateMapStyle(isSatellite: isChangeMapStyleButtonTapped)
    }
}

final class MapBoxDetailViewController: UIViewController {
    internal var mapView: MapView!
    var selectedDetails: ObjectDetails
    private var pointAnnotationManager: PointAnnotationManager!
    @Binding var isChangeMapStyleButtonTapped: Bool
    
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
        
             let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiYm96aWRhcnMyNyIsImEiOiJjazh6eGM0MTUwODNrM25uNDEzeTN0bGNxIn0.ruHpEdNSJu5NnmxEXmvYFg")
             
             let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: selectedDetails.latitude, longitude: selectedDetails.longitude), zoom: 15)
             
             
             let myMapInitOptions = MapInitOptions(
                 resourceOptions: myResourceOptions,
                 cameraOptions: cameraOptions,
                 styleURI: isChangeMapStyleButtonTapped ? .satellite : .light
             )
             
             let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
                    mapView = MapView(frame: frame, mapInitOptions: myMapInitOptions)
             mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
             
             self.view.addSubview(mapView)
             
             pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
             
             setPin()
        
//            updateMapStyle(isSatellite: isChangeMapStyleButtonTapped)
        
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
    
//    func updateMapStyle(isSatellite: Bool) {
//        mapView.mapboxMap.style.uri = isSatellite ? .satelliteStreets : .streets
//    }
}


