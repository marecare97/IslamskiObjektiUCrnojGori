//
//  ReligiousActivityRowView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 21.5.23..
//

import SwiftUI

struct ReligiousActivityRowView: View {
    let title: String
    let value: Bool?
    
    var body: some View {
        HStack {
            Text(title)
                .font(RFT.medium.swiftUIFont(size: 15))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value != nil ? (value! ? "DA" : "NE") : "/")
                .font(RFT.bold.swiftUIFont(size: 15))
                .foregroundColor(.white)
        }
    }
}


struct ReligiousActivityRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReligiousActivityRowView(title: "", value: nil)
    }
}
