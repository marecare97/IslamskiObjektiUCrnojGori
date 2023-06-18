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
    
    let yearFromDropDown = Array(stride(from: 1000, through: 2000, by: 50))
    let yearToDropDown = Array(stride(from: 1000, through: 2023, by: 50))
    
    @State var isFromYearBuiltBottomSheetPresented = false
    @State var isToYearBuiltBottomSheetPresented = false
    
    @State var selectedFromYear: Int = 1000
    @State var selectedToYear: Int = 2023
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
                    
                    Text(Str.yearBuilt)
                    yearBuiltFilterView
                    
                }
                .padding(.top, 130)
                .padding(.bottom, 50)
            }
            .padding(.leading, 30)
        }
        .frame(width: UIScreen.main.bounds.width / 1.3)
        .sheet(isPresented: $isFromYearBuiltBottomSheetPresented, content: {
            VStack {
                HStack {
                    Text("Godina izgradnje")
                        .font(.system(.headline, weight: .bold))
                    Spacer()
                }
                .padding()
                Divider()
                ScrollView(showsIndicators: false) {
                    fromYearDropDownView
                }
            }
            .presentationDetents([.fraction(0.3)])
        })
        .sheet(isPresented: $isToYearBuiltBottomSheetPresented, content: {
            VStack {
                HStack {
                    Text("Godina izgradnje")
                        .font(.system(.headline, weight: .bold))
                    Spacer()
                }
                .padding()
                Divider()
                ScrollView(showsIndicators: false) {
                    toYearDropDownView
                }
            }
            .presentationDetents([.fraction(0.3)])
        })
        .onChange(of: selectedTowns) { _ in
            viewModel.filterObjectsByTown(selectedTowns: selectedTowns)
        }
        .onChange(of: selectedMajlises) { _ in
            viewModel.filterObjectsByMajlises(selectedMajlises: selectedMajlises)
        }
        .onChange(of: selectedObjectTypes) { _ in
            viewModel.filterObjectsByObjectTypes(selectedObjectTypes: selectedObjectTypes)
        }
        .onChange(of: selectedFromYear) { newValue in
            viewModel.filterObjectsByYearBuilt(fromYear: newValue, toYear: selectedToYear)
        }
        .onChange(of: selectedToYear) { newValue in
            viewModel.filterObjectsByYearBuilt(fromYear: selectedFromYear, toYear: newValue)
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
    
    var yearBuiltFilterView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Od:")
                ZStack {
                    Rectangle()
                        .fill(.white
                            .shadow(.drop(radius: 2, x: 5, y: 5)))
                        .frame(width: 90, height: 30)
                        .border(.white, width: 0.5)
                    Text("\(selectedFromYear)")
                }
                .onTapGesture {
                    isFromYearBuiltBottomSheetPresented = true
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Do:")
                ZStack {
                    Rectangle()
                        .fill(.white
                            .shadow(.drop(radius: 2, x: 5, y: 5)))
                        .frame(width: 90, height: 30)
                        .border(.white, width: 0.5)
                    Text("\(selectedToYear)")
                }
                .onTapGesture {
                    isToYearBuiltBottomSheetPresented = true
                }
            }
            
            Spacer()
        }
    }
    
    var fromYearDropDownView: some View {
        LazyVStack {
            ForEach(yearFromDropDown, id: \.self) { year in
                let isSelected = selectedFromYear == year
                let scale = isSelected ? 1.2 : 1
                let textColor = isSelected ? Color.black : Color.gray
                
                Button {
                    selectedFromYear = year
                    isFromYearBuiltBottomSheetPresented = false
                } label: {
                    Text("\(year)")
                        .padding()
                        .fontWeight(isSelected ? .bold : .regular)
                        .scaleEffect(x: scale, y: scale)
                        .foregroundColor(textColor)
                }
            }
        }
    }
    
    var toYearDropDownView: some View {
        LazyVStack {
            ForEach(yearToDropDown, id: \.self) { year in
                let isSelected = selectedToYear == year
                let scale = isSelected ? 1.2 : 1
                let textColor = isSelected ? Color.black : Color.gray
                
                Button {
                    selectedToYear = year
                    isToYearBuiltBottomSheetPresented = false
                } label: {
                    Text("\(year)")
                        .padding()
                        .fontWeight(isSelected ? .bold : .regular)
                        .scaleEffect(x: scale, y: scale)
                        .foregroundColor(textColor)
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
