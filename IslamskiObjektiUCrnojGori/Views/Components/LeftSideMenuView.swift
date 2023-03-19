//
//  LeftSideMenuView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation
import SwiftUI
import SFSafeSymbols

struct LeftSideMenuView: View {
    typealias S = TK.LeftSideMenu
    @State var isQiblaViewPresented = false
    @State var isNotificationsViewPresented = false
    @State var isAboutProjectViewPresented = false
    
    var body: some View {
        ZStack {
            Img.drawerMenu.swiftUIImage
                .resizable()
                .ignoresSafeArea(edges: .bottom)
            VStack(alignment: .leading, spacing: 20) {

                MenuRow(image: Img.icon4.swiftUIImage, text: S.objects)

                Divider()
                    .offset(x: -12)

                VStack(alignment: .leading, spacing: 20) {
                    Text(S.sectionTitle)

                    MenuRow(image: Img.icon4.swiftUIImage, text: S.closestObject)

                    MenuRow(image: Img.icon2.swiftUIImage, text: S.vaktija)

                    MenuRow(image: Img.icon1.swiftUIImage, text: S.kibla) {
                        isQiblaViewPresented = true
                    }

                    MenuRow(image: Img.icon3.swiftUIImage, text: S.calendar)

                }

                Divider()
                    .offset(x: -12)

                MenuRow(image: Image(systemSymbol: .bellCircleFill), text: S.notifications) {
                    isNotificationsViewPresented = true
                }

                MenuRow(image: Image(systemSymbol: .infoCircleFill), text: S.about) {
                    isAboutProjectViewPresented = true
                }

                MenuRow(
                    image: Image(systemSymbol: .link),
                    foreGroundColor: .green,
                    text: S.usefulLinks,
                    textColor: .green
                )

                Spacer()
                
                HStack {
                 Spacer()
                    Img.fond.swiftUIImage
                        .resizable()
                        .frame(width: 100, height: 100)
                        .offset(x: -15) //needed due to image being 200 x 215 px
                    
                    Spacer()
                }
                .padding()
            }
            .padding()
            .padding(.top, 120)
        }
        .fullScreenCover(isPresented: $isQiblaViewPresented) {
            QiblaView()
        }
        .fullScreenCover(isPresented: $isAboutProjectViewPresented) {
            AboutView()
        }
        .fullScreenCover(isPresented: $isNotificationsViewPresented) {
            NotificationsView()
        }
    }
    
    
    struct MenuRow: View {
        let foreGroundColor: Color
        let text: String
        let image: Image
        var textColor: Color
        let onTapGestureAction: () -> Void
        
        init(
            image: Image,
            foreGroundColor: Color = .gray,
            text: String,
            textColor: Color = .black,
            onTapGestureAction: @escaping () -> Void = { }
        ) {
            self.image = image
            self.foreGroundColor = foreGroundColor
            self.text = text
            self.textColor = textColor
            self.onTapGestureAction = onTapGestureAction
        }
        
        var body: some View {
            HStack(spacing: 12) {
                image
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(foreGroundColor)
                
                Text(text)
                    .bold()
                    .foregroundColor(textColor)
                
                Spacer()
            }
            .onTapGesture(perform: onTapGestureAction)
        }
    }
}
