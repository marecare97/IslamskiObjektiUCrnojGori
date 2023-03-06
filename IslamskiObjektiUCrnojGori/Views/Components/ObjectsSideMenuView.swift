//
//  ObjectsSideMenuView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 6.3.23..
//

import SwiftUI

struct ObjectsSideMenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Objekti...")
                
                Spacer()
            }
            HStack {
                Text("Objekti...")
                
                Spacer()
            }
            HStack {
                Text("Objekti...")
                
                Spacer()
            }
            HStack {
                Text("Objekti...")
                
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.red)
        .edgesIgnoringSafeArea(.all )
    }
}

struct ObjectsSideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectsSideMenuView()
    }
}
