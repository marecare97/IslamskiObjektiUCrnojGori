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
    
    var sortedObjects: [ObjectDetails]
    
    var body: some View {
        VStack {
            CustomNavBar(navBarTitle: TK.LeftSideMenu.closestObject)
            VStack {
                objectTypeFilterView
                    .padding(.vertical)
                    .background(Color.gray)
                List {
                    ForEach(sortedObjects) { object in
                        NavigationLink {
                            ObjectDetailsView(details: object)
                        } label: {
                            ObjectItem(details: object)
                                .padding()
                        }
                        
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    var objectTypeFilterView: some View {
        HStack {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                
                ForEach(mosqueTypes, id: \.self) { mosque in
                    HStack(alignment: .center, spacing: 20) {
                        
                        Spacer()
                        
                        Image(systemSymbol: .square)
                            .foregroundColor(.green)
                        
                        Text(mosque)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct NearestMosqueView_Previews: PreviewProvider {
    static var previews: some View {
        NearestMosqueView(sortedObjects: [])
    }
}
