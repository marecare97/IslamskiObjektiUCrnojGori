//
//  ObjectDetailsView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI
import ExpandableText

struct ObjectDetailsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    typealias S = TK.ObjectDetails
    let details: ObjectDetails
    
    var body: some View {
        ZStack(alignment: .top) {
            contentView
            customNavBar
        }
        .navigationBarBackButtonHidden()
    }
    
    var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                PagingView(urls: details.images) { str in
                    RemoteImage(url: str)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                Text(details.name)
                    .font(PFT.semiBold.swiftUIFont(size: 30))
                    .lineLimit(2)
                    .padding(.bottom)
                    .foregroundColor(.black)
                
                ExpandableText(text: details.about)
                    .font(RFT.bold.swiftUIFont(size: 15))
                    .lineLimit(5)
                    .foregroundColor(.gray)
                    .expandButton(TextSet(text: "Prikaži još ↓", font: .body, color: .green))
                    .collapseButton(TextSet(text: "Prikaži manje ↑", font: .body, color: .green))
                    .expandAnimation(.easeOut)
                
                Text(S.basicInfo)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.black)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                basicInformationView
                
                Text(S.geoInfo)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.black)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                geoInformationView
                
                Text(S.dimensions)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.black)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                Text(details.baseDimensions ?? "")
                    .font(RFT.bold.swiftUIFont(size: 15))
                    .foregroundColor(.black)
            }
            .padding()
        }
        .background(.white)
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
            Button(action: {
                withAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Img.back.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            Text(details.name)
                .foregroundColor(.white)
                .padding(.leading)
            
            Spacer()
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
    
    var basicInformationView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(S.city)
                Text(S.medzlis)
                Text(S.objectType)
                Text(S.built)
            }
            .font(RFT.medium.swiftUIFont(size: 15))
            .foregroundColor(.gray)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                Text(details.town.name)
                Text(details.majlis.name)
                Text(details.objType.name)
                if let yearBuilt = details.yearBuilt {
                    Text("\(yearBuilt)")
                } else {
                    Text(details.yearBuiltText ?? "")
                }
            }
            .font(RFT.bold.swiftUIFont(size: 15))
            .foregroundColor(.black)
            
        }
    }
    
    var geoInformationView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(S.latitude)
                Text(S.longitude)
                Text(S.altitude)
            }
            .font(RFT.medium.swiftUIFont(size: 15))
            .foregroundColor(.gray)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                Text("\(details.latitude)")
                Text("\(details.longitude)")
                Text("\(details.elevation)")
            }
            .font(RFT.bold.swiftUIFont(size: 15))
            .foregroundColor(.black)
        }
    }
}
