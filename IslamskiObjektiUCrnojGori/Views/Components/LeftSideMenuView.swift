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
    
    @State private var navigationDestination: NavigationDestination? = nil
    
    @State var longitude: Double?
    @State var latitude: Double?
    
    @Binding var allObjects: [ObjectDetails]
    
    enum NavigationDestination {
        case objectsView
        case nearestMosqueView
        case notificationsView
        case calendarView
        case quiblaView
        case aboutView
    }
    
    var body: some View {
        ZStack {
            navigationLinks
            Img.drawerMenu.swiftUIImage
                .resizable()
                .ignoresSafeArea(edges: .bottom)
            VStack(alignment: .leading, spacing: 20) {
                
                MenuRow(image: Img.icon4.swiftUIImage, text: S.objects) {
                    navigationDestination = .objectsView
                }
                
                Divider()
                    .offset(x: -12)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(S.sectionTitle)
                    
                    MenuRow(image: Img.icon4.swiftUIImage, text: S.closestObject) {
                        navigationDestination = .nearestMosqueView
                    }
                    
                    MenuRow(image: Img.icon2.swiftUIImage, text: S.vaktija)
                    
                    MenuRow(image: Img.icon1.swiftUIImage, text: S.kibla) {
                        navigationDestination = .quiblaView
                    }
                    
                    MenuRow(image: Img.icon3.swiftUIImage, text: S.calendar) {
                        navigationDestination = .calendarView
                    }
                    
                }
                
                Divider()
                    .offset(x: -12)
                
                MenuRow(image: Image(systemSymbol: .bellCircleFill), text: S.notifications) {
                    navigationDestination = .notificationsView
                }
                
                MenuRow(image: Image(systemSymbol: .infoCircleFill), text: S.about) {
                    navigationDestination = .aboutView
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
    }
    
    // MARK: -- Navigation
    var navigationLinks: some View {
        VStack {
            NavigationLink(
                destination: ObjectListView(allObjects: allObjects),
                tag: NavigationDestination.objectsView,
                selection: $navigationDestination,
                label: { }
            )
            
            NavigationLink(
                destination: NearestMosqueView(allObjects: allObjects),
                tag: NavigationDestination.nearestMosqueView,
                selection: $navigationDestination,
                label: { }
            )
            
            NavigationLink(
                destination: NotificationsView(),
                tag: NavigationDestination.notificationsView,
                selection: $navigationDestination,
                label: { }
            )
            
            NavigationLink(
                destination: QiblaView(),
                tag: NavigationDestination.quiblaView,
                selection: $navigationDestination,
                label: { }
            )
            
            NavigationLink(
                destination: AboutView(),
                tag: NavigationDestination.aboutView,
                selection: $navigationDestination,
                label: { }
            )
            
            NavigationLink(
                destination: CalendarView(latitude: latitude, longitude: longitude),
                tag: NavigationDestination.calendarView,
                selection: $navigationDestination,
                label: { }
            )
        }
        .hidden()
        .frame(width: 0, height: 0)
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
