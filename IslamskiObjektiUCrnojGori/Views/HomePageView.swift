//
//  HomePageView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23..
//

import SwiftUI
import MapboxMaps

struct HomePageView: View {
    
    var body: some View {
        VStack {
            MapBoxMapView()
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
