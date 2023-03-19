//
//  RightSideMenu.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 19.3.23..
//

import SwiftUI

struct RightSideMenu: View {
    typealias Str = TK.RightSideMenu
    let uniqueTowns: [Location]
    let uniqueMajlis: [Location]
    let uniqueObjectTypes: [ObjType]
    
    @State var selectedTowns = [Location]()
    @State var selectedMajlises = [Location]()
    @State var selectedObjectTypes = [ObjType]()
    
    @Binding var objectsDetails: [ObjectDetails]
    
    private let columns = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 4))]

    
    init(objectsDetails: Binding<[ObjectDetails]>) {
        self._objectsDetails = objectsDetails
        let uniqueValues = objectsDetails.wrappedValue.uniqueValues()
        self.uniqueTowns = Array(uniqueValues.towns)
        self.uniqueMajlis = Array(uniqueValues.majlises)
        self.uniqueObjectTypes = Array(uniqueValues.objTypes)
    }
    
    var body: some View {
        ZStack {
            Img.filter.swiftUIImage
                .resizable()
                .ignoresSafeArea(edges: .bottom)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text(Str.objectType)
                    objectTypeFilterView
                    
                    Text(Str.majlis)
                    majlisesFilterView
                    
                    Text(Str.town)
                    townsFilterView
                    
                }
                .padding(.top, 130)
            }
            .padding(.leading, 30)
        }
        .frame(width: UIScreen.main.bounds.width / 1.3)
        .onChange(of: selectedTowns) { _ in
            objectsDetails = objectsDetails.filterObjects(towns: selectedTowns, majlises: selectedMajlises, yearBuiltFrom: 0, yearBuiltTo: Int.max, objTypes: selectedObjectTypes)
        }
    }
    
    var objectTypeFilterView: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(uniqueObjectTypes, id: \.name) { type in
                HStack {
                    if selectedObjectTypes.contains(type) {
                        Image(systemSymbol: .checkmarkSquareFill)
                            .foregroundColor(.green)
                            .onTapGesture {
                                selectedObjectTypes = selectedObjectTypes.filter { $0 != type }
                            }
                    } else {
                        Image(systemSymbol: .square)
                            .onTapGesture {
                                selectedObjectTypes.append(type)
                            }
                    }
                    Text(type.name)
                }
            }
        }
    }
    
    var majlisesFilterView: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(uniqueMajlis, id: \.name) { majlis in
                HStack {
                    if selectedMajlises.contains(majlis) {
                        Image(systemSymbol: .checkmarkSquareFill)
                            .foregroundColor(.green)
                            .onTapGesture {
                                selectedMajlises = selectedMajlises.filter { $0 != majlis }
                            }
                    } else {
                        Image(systemSymbol: .square)
                            .onTapGesture {
                                selectedMajlises.append(majlis)
                            }
                    }
                    Text(majlis.name)
                }
                
            }
        }
    }
    
    var townsFilterView: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(uniqueTowns, id: \.name) { town in
                HStack {
                    if selectedTowns.contains(town) {
                        Image(systemSymbol: .checkmarkSquareFill)
                            .foregroundColor(.green)
                            .onTapGesture {
                                selectedTowns = selectedTowns.filter { $0 != town }
                            }
                    } else {
                        Image(systemSymbol: .square)
                            .onTapGesture {
                                selectedTowns.append(town)
                            }
                    }
                    Text(town.name)
                }
            }
        }
    }
}

struct RightSideMenu_Previews: PreviewProvider {
    static var previews: some View {
        RightSideMenu(objectsDetails: .constant([]))
    }
}
