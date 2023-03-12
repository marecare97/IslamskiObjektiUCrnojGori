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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Spacer()
            
            MenuRow(image:  Image(systemSymbol: .buildingColumns), text: S.objects)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 20) {
                Text(S.sectionTitle)
                
                MenuRow(image: Image(systemSymbol: .buildingColumns), text: S.closestObject)
                
                MenuRow(image: Image(systemSymbol: .noteText), text: S.vaktija)
                
                MenuRow(image: Image(systemSymbol: .buildingColumns), text: S.kibla)
                
                MenuRow(image: Image(systemSymbol: .calendar), text: S.calendar)
                
            }
            
            Divider()
            
            MenuRow(image: Image(systemSymbol: .bellCircleFill), text: S.notifications)
            
            MenuRow(image: Image(systemSymbol: .infoCircleFill), text: S.about)
            
            MenuRow(
                image: Image(systemSymbol: .link),
                foreGroundColor: .green,
                text: S.usefulLinks
            )
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .edgesIgnoringSafeArea(.horizontal)
    }
    
    
    struct MenuRow: View {
        let foreGroundColor: Color
        let text: String
        let image: Image
        
        init(
            image: Image,
            foreGroundColor: Color = .black,
            text: String
        ) {
            self.image = image
            self.foreGroundColor = foreGroundColor
            self.text = text
        }
        
        var body: some View {
            HStack(spacing: 12) {
                image
                
                Text(text)
                    .bold()
                
                Spacer()
            }
            .foregroundColor(foreGroundColor)
        }
    }
}
