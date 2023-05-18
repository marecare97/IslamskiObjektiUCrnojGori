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
    
    let sortedObjects: [ObjectDetails]
    
    let mosqueTypes = Mosque.mosqueTypes
    @State var selectedMosqueTypes = [MosqueTypes]()
    
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
        .onChange(of: selectedMosqueTypes) { _ in
            //
        }
    }
    
    var objectTypeFilterView: some View {
        HStack {
            LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                ForEach(mosqueTypes, id: \.self) { mosque in
                    HStack(alignment: .center, spacing: 20) {
                        if selectedMosqueTypes.contains(mosque) {
                            Image(systemSymbol: .checkmarkSquareFill)
                                .foregroundColor(.green)
                                .onTapGesture {
                                    selectedMosqueTypes = selectedMosqueTypes.filter { $0 != mosque }
                                }
                            
                        } else {
                            Image(systemSymbol: .square)
                                .foregroundColor(.green)
                                .onTapGesture {
                                    selectedMosqueTypes.append(mosque)
                                }
                        }
                        Text(mosque.name)
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
}
