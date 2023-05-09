//
//  NearestMosqueView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 9.5.23..
//

import SwiftUI

struct NearestMosqueView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let columns = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 3))]

    let mosqueTypes = ["Sabah", "Jacija", "Podne", "Dzuma", "Ikindija", "Teravija", "Akšam", "Bajram"]
    
    @State var allObjects: [ObjectDetails]

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(mosqueTypes, id: \.self) { mosque in
                        HStack {
                            Image(systemSymbol: .square)
                                .foregroundColor(.green)
                            Text(mosque)
                        }
                    }
                }
            }
            List {
                ForEach(allObjects) { object in
                    NavigationLink {
                        ObjectDetailsView(details: object)
                    } label: {
                        ObjectItem(details: object)
                            .padding()
                    }
                    
                }
            }
        }
//        .navigationBarBackButtonHidden()
    }
}

struct NearestMosqueView_Previews: PreviewProvider {
    static var previews: some View {
        NearestMosqueView(allObjects: [])
    }
}
