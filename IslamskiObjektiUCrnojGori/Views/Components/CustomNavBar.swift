//
//  CustomNavBar.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 9.5.23..
//

import SwiftUI

struct CustomNavBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let navBarTitle: String?
    
    var body: some View {
        customNavBar
    }
    
    var customNavBar: some View {
        HStack {
            ZStack {
                Img.toolbar.swiftUIImage
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                defaultNavBar
            }
        }
        .background(Color.clear)
        .frame(maxHeight: 50)
    }
    
    var defaultNavBar: some View {
        HStack {
            Button {
                withAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Img.back.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Text(navBarTitle ?? "")
                .foregroundColor(.white)
                .padding(.leading)
            
            Spacer()
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}

struct CustomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBar(navBarTitle: "")
    }
}
