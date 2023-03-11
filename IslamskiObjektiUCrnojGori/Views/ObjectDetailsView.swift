//
//  ObjectDetailsView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI

struct ObjectDetailsView: View {
    typealias S = TK.ObjectDetails
    let details: ObjectDetails
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                PagingView(urls: details.images) { str in
                    RemoteImage(url: str)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                Text(details.name)
                    .lineLimit(2)
                    .bold()
                
                Text(details.about)
                
                Text(S.basicInfo)
                basicInformationView
                
                Text(S.geoInfo)
                geoInformationView
                
                Text(S.dimensions)
                Text(details.baseDimensions ?? "")
            }
            .padding()
        }
    }
    
    var basicInformationView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(S.city)
                Text(S.medzlis)
                Text(S.objectType)
                Text(S.built)
            }
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(details.town.name)
                Text(details.majlis.name)
                Text(details.objType.name)
                if let yearBuilt = details.yearBuilt {
                    Text("\(yearBuilt)")
                } else {
                    Text(details.yearBuiltText ?? "")
                }
            }
            
        }
    }
    
    var geoInformationView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(S.latitude)
                Text(S.longitude)
                Text(S.altitude)
            }
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(details.latitude)")
                Text("\(details.longitude)")
                Text("\(details.elevation)")
            }
        }
    }
}
