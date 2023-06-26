//
//  SplashScreen.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 18.3.23..
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Img.splashBgd.swiftUIImage
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .bottom)
            VStack {
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Img.fond2.swiftUIImage
                        .resizable()
                        .frame(width: 150, height: 150)
                    
                    Spacer()
                }
            }
            .padding(.bottom)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
