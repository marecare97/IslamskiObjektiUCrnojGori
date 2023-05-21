//
//  ObjectDetailsPreview.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 25.3.23..
//

import SwiftUI
import SDWebImageSwiftUI

struct ObjectDetailsPreview: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    typealias S = TK.ObjectDetailsPreview
    let details: ObjectDetails?
    
    var body: some View {
        HStack {
            if let objDetails = details {
                WebImage(url: URL(string: objDetails.image))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.green, lineWidth: 2)
                    )
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(objDetails.name)
                        .font(RFT.bold.swiftUIFont(size: 15))
                        .lineLimit(2)
                        .foregroundColor(.white)
                    
                    Text(objDetails.objType.name)
                        .font(RFT.bold.swiftUIFont(size: 13))
                        .lineLimit(1)
                        .foregroundColor(.gray)
                    
                    HStack {
                        getObjectIcon(objName: objDetails.objType.icon)
                            .resizable()
                            .frame(width: 20, height: 30)
                        
                        Text(objDetails.town.name)
                            .font(RFT.bold.swiftUIFont(size: 13))
                            .lineLimit(1)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text(S.detailed + " >")
                                .font(PFT.semiBold.swiftUIFont(size: 13))
                                .foregroundColor(.green)
                        }
                    }
                }
            } else {
                Text("No object details available")
            }
        }
        .padding()
        .background(.black)
        .edgesIgnoringSafeArea(.all)
        //        .onTapGesture {
        //            // Dismiss the sheet when tapped outside of it
        //            dismissSheet()
        //        }
    }
    
    func getObjectIcon(objName: String) -> Image {
        let iconMap: [String: Image] = [
            "mosque": Img.mosque.swiftUIImage,
            "locality": Img.locality.swiftUIImage,
            "institution": Img.institution.swiftUIImage,
            "turbe": Img.turbe.swiftUIImage,
            "masjid": Img.masjid.swiftUIImage
        ]
        return iconMap[objName] ?? Img.mosque.swiftUIImage
    }
}

struct ObjectDetailsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetailsPreview(details: nil)
    }
}
