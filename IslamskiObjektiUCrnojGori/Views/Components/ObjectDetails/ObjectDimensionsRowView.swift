//
//  DimenstionsRowView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 21.5.23..
//

import SwiftUI

struct ObjectDimensionsRowView: View {
    let title: String
    let value: Any?
    
    var body: some View {
        HStack {
            Text(title)
                .font(RFT.medium.swiftUIFont(size: 15))
                .foregroundColor(.gray)
            
            Spacer()
            
            if let intValue = value as? Int {
                Text("\(intValue)")
                    .font(RFT.bold.swiftUIFont(size: 15))
                    .foregroundColor(.white)
            } else if let stringValue = value as? String {
                Text(stringValue)
                    .font(RFT.bold.swiftUIFont(size: 15))
                    .foregroundColor(.white)
            } else {
                Text("/")
                    .font(RFT.bold.swiftUIFont(size: 15))
                    .foregroundColor(.white)
            }
        }
    }
}

struct DimenstionsRowView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDimensionsRowView(title: "", value: nil)
    }
}
