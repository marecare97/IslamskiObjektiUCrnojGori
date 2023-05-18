//
//  IslamskiObjektiUCrnojGoriApp.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23..
//

import SwiftUI

typealias Img = Asset.Images
typealias RFT = FontFamily.Roboto // font family Roboto
typealias PFT = FontFamily.Poppins // font family Poppins

@main
struct IslamskiObjektiUCrnojGoriApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LocationPermissionView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
