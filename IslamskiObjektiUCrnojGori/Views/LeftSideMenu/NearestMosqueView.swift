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
    
    // MARK: filter objects
    var filteredObjects: [ObjectDetails] {
        let selectedTypes = Set(selectedMosqueTypes)
        
        if selectedTypes.isEmpty {
            return sortedObjects // Return all objects when no filter is applied
        } else {
            return sortedObjects.filter { object in
                let objectTypes = Set(object.mosqueTypes)
                return selectedTypes.isSubset(of: objectTypes)
            }
        }
    }
    
    var body: some View {
        VStack {
            CustomNavBar(navBarTitle: TK.LeftSideMenu.closestObject)
            objectTypeFilterView
                .padding(.vertical)
            List {
                ForEach(filteredObjects) { object in
                    NavigationLink {
                        ObjectDetailsView(details: object)
                    } label: {
                        ObjectItem(details: object)
                            .padding()
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
            ZStack {
                Color.gray
                    .opacity(0.2)
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
//                                        print("clicked object", selectedMosqueTypes)
                                    }
                            }
                            Text(mosque.name)
                        }
                    }
                }
            }
        }
        .frame(height: 150)
    }
    
    struct NearestMosqueView_Previews: PreviewProvider {
        static var previews: some View {
            NearestMosqueView(sortedObjects: [])
        }
    }
}
