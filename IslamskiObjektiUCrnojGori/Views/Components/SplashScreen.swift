//
//  SplashScreen.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 18.3.23..
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Img.splashBgd.swiftUIImage
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(edges: .bottom)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
