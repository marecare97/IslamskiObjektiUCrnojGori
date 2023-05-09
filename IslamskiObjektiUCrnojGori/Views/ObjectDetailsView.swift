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
            CustomNavBar(navBarTitle: details.name)
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
                    .foregroundColor(.white)
                
                ExpandableText(text: details.about)
                    .font(RFT.bold.swiftUIFont(size: 15))
                    .lineLimit(5)
                    .foregroundColor(.gray)
                    .expandButton(TextSet(text: "Prikaži još ↓", font: .body, color: .green))
                    .collapseButton(TextSet(text: "Prikaži manje ↑", font: .body, color: .green))
                    .expandAnimation(.easeOut)
                
                Text(S.basicInfo)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                basicInformationView
                
                if let alternativeNames = details.alternativeNames {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(S.otherNames + ":")
                            .font(RFT.bold.swiftUIFont(size: 15))
                            .foregroundColor(.gray)
                        
                        Text(alternativeNames)
                            .font(RFT.medium.swiftUIFont(size: 15))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical)
                }
                
                Text(S.geoInfo)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                geoInformationView
                
//                MapBoxMapView(
//                    allObjects: .constant([]),
//                    filteredObjects: .constant([]),
//                    selectedObject: details,
//                    isChangeMapStyleButtonTapped: .constant(false),
//                    didTapOnObject: { _ in }
//                )
                
                Text(S.dimensions)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                Text(details.baseDimensions ?? "")
                    .font(RFT.bold.swiftUIFont(size: 15))
                    .foregroundColor(.white)
            }
            .padding()
        }
        .background(.black)
    }
    
    var basicInformationView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(S.city)
                Text(S.medzlis)
                Text(S.objectType)
                Text(S.built)
                Text(S.renewed)
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
                if let yearRenewed = details.yearRebuilt {
                    Text("\(yearRenewed)")
                } else {
                    Text("N/A")
                }
            }
            .font(RFT.bold.swiftUIFont(size: 15))
            .foregroundColor(.white)
            
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
                Text("\(String(format: "%.2f", details.elevation)) m")
            }
            .font(RFT.bold.swiftUIFont(size: 15))
            .foregroundColor(.white)
        }
    }
}
