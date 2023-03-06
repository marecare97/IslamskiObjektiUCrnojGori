//
//  HomePageView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 4.3.23.§.
//

import SwiftUI
import MapboxMaps

struct HomePageView: View {
    @State var showSideMenu = false
    
    var body: some View {
        let drag = DragGesture().onEnded {
            if $0.translation.width < -100 {
                withAnimation {
                    self.showSideMenu = false
                }
            }
        }
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    MainMapView(showSideMenu: self.$showSideMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showSideMenu ? geometry.size.width/2 : 0)
                        .disabled(self.showSideMenu ? true : false)
                    
                    if self.showSideMenu {
                        ObjectsSideMenuView()
                            .frame(width: geometry.size.width / 2)
                            .transition(.move(edge: .leading ))
                    }
                }
                .gesture(drag)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showSideMenu.toggle()
                    }
                }, label: {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                })
            ))
        }
    }
}

struct MainMapView: View {
    @Binding var showSideMenu: Bool
    
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
