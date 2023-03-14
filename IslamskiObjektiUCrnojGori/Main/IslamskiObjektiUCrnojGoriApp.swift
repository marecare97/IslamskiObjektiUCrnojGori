//
//  IslamskiObjektiUCrnojGoriApp.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23..
//

import SwiftUI

typealias Img = Asset.Images
//typealias RFT = FontFamily. // font family Roboto
//typealias PFT = FontFamily.Canela // font family Canela

@main
struct IslamskiObjektiUCrnojGoriApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LocationPermissionView()
            }
        }
    }
}
