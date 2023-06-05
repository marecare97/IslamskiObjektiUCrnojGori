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
    
    @Binding var selectedTowns: [Location]
    @Binding var selectedMajlises: [Location]
    @Binding var selectedObjectTypes: [ObjType]
    
    var objectDetails: [ObjectDetails]
    
    @EnvironmentObject var viewModel: HomePageView.ViewModel
    
    private let columns = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 4))]
    
    
    init(
        selectedTowns: Binding<[Location]>,
        selectedMajlises: Binding<[Location]>,
        selectedObjectTypes: Binding<[ObjType]>,
        objectDetails: [ObjectDetails])
    {
        self._selectedTowns = selectedTowns
        self._selectedMajlises = selectedMajlises
        self._selectedObjectTypes = selectedObjectTypes
        self.objectDetails = objectDetails
        let uniqueValues = objectDetails.uniqueValues()
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
            viewModel.filterObjectsByTown(selectedTowns: selectedTowns)
        }
        .onChange(of: selectedMajlises) { _ in
            viewModel.filterObjectsByMajlises(selectedMajlises: selectedMajlises)
        }
        .onChange(of: selectedObjectTypes) { _ in
            viewModel.filterObjectsByObjectTypes(selectedObjectTypes: selectedObjectTypes)
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
        RightSideMenu(selectedTowns: .constant(([])), selectedMajlises: .constant(([])), selectedObjectTypes: .constant(([])), objectDetails: [])
    }
}
