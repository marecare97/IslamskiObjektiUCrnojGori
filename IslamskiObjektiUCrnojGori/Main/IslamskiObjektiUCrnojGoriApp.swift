//
//  IslamskiObjektiUCrnojGoriApp.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23..
//

import SwiftUI

typealias Img = Asset.Images

@main
struct IslamskiObjektiUCrnojGoriApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomePageView()
            }
        }
    }
}
