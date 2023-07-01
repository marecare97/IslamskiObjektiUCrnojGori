//
//  ObjectDetailsView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import SwiftUI
import ExpandableText

struct ObjectDetailsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    typealias S = TK.ObjectDetails
    let details: ObjectDetails
    
    @State private var navigationDestination: NavigationDestination? = nil
    @State var isChangeMapStyleButtonTapped = false
    
    enum NavigationDestination {
        case reportAProblemView
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            navigationLinks
            contentView
            CustomNavBar(navBarTitle: details.name)
        }
        .navigationBarBackButtonHidden()
    }
    
    var contentView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                PagingView(urls: details.images, objectLat: details.latitude, objectLong: details.longitude, objectId: details.id) { str in
                    RemoteImage(url: str)
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                
                allObjectInfoView
                    .padding()
                
                // MARK: Prijavi problem dugme
                Button {
                    navigationDestination = .reportAProblemView
                } label: {
                    ZStack {
                        Color.green
                        Text(S.reportAProblem)
                    }
                    .cornerRadius(20, corners: .allCorners)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .padding(.horizontal)
                }
            }
        }
        .background(.black)
    }
    
    // MARK: Views combined
    var allObjectInfoView: some View {
        LazyVStack {
            HStack {
                Text(details.name)
                    .font(PFT.semiBold.swiftUIFont(size: 30))
                    .lineLimit(2)
                    .padding(.bottom)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            ExpandableText(text: details.about)
                .font(RFT.bold.swiftUIFont(size: 15))
                .lineLimit(5)
                .foregroundColor(.gray)
                .expandButton(TextSet(text: "Prikaži još ↓", font: .body, color: .green))
            //                .collapseButton(TextSet(text: "Prikaži manje ↑", font: .body, color: .green))
                .expandAnimation(.easeOut)
            
            // MARK: Osnovni podaci
            HStack {
                Text(S.basicInfo)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                Spacer()
            }
            
            basicInformationView
            
            // MARK: Drugi nazivi
            HStack {
                if let alternativeNames = details.alternativeNames {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(S.otherNames + ":")
                            .font(RFT.bold.swiftUIFont(size: 15))
                            .foregroundColor(.gray)
                        
                        Text(alternativeNames)
                            .font(RFT.medium.swiftUIFont(size: 15))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical)
                }
                Spacer()
            }
            
            // MARK: Geografski podaci
            HStack {
                Text(S.geoInfo)
                    .font(RFT.bold.swiftUIFont(size: 20))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .padding(.vertical)
                
                Spacer()
            }
            
            geoInformationView
            
            mapBoxView
                .padding(.vertical)
            
            // MARK: Dimenzije
            if details.baseDimensions != nil {
                HStack {
                    Text(S.dimensions)
                        .font(RFT.bold.swiftUIFont(size: 20))
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .padding(.vertical)
                    
                    Spacer()
                }
                
                dimensionsView
            }
            
            // MARK: Vjerska aktivnost
            if details.sabah != nil {
                HStack {
                    Text(S.religiousActivity)
                        .font(RFT.bold.swiftUIFont(size: 20))
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .padding(.vertical)
                    
                    Spacer()
                }
                
                religiousActivityView
            }
        }
    }
    
    
    // MARK: Views sliced
    var basicInformationView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ObjectDimensionsRowView(title: S.city, value: details.town.name)
            ObjectDimensionsRowView(title: S.medzlis, value: details.majlis.name)
            ObjectDimensionsRowView(title: S.objectType, value: details.objType.name)
            if let yearBuiltText = details.yearBuiltText, !yearBuiltText.isEmpty {
                ObjectDimensionsRowView(title: S.built, value: yearBuiltText)
            } else if let yearBuild = details.yearBuilt {
                ObjectDimensionsRowView(title: S.built, value: yearBuild)
            }
            
            if let yearRenewed = details.yearRebuilt {
                ObjectDimensionsRowView(title: S.renewed, value: yearRenewed)
            } else { }
        }
    }
    
    var geoInformationView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(S.latitude)
                Text(S.longitude)
                Text(S.altitude)
            }
            .font(RFT.medium.swiftUIFont(size: 15))
            .foregroundColor(.gray)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                Text("\(details.latitude)")
                Text("\(details.longitude)")
                Text("\(String(format: "%.2f", details.elevation)) m")
            }
            .font(RFT.bold.swiftUIFont(size: 15))
            .foregroundColor(.white)
        }
    }
    
    var dimensionsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let baseDimensions = details.baseDimensions {
                ObjectDimensionsRowView(title: S.basis, value: "\(baseDimensions) [m]")
            }
            
            if let innerVault = details.innerDomeHeight {
                ObjectDimensionsRowView(title: S.innerVault, value: "\(innerVault) m")
            }
            
            if let minaretHeight = details.minaretHeight {
                ObjectDimensionsRowView(title: S.minaretHeight, value: "\(minaretHeight) m")
            }
            
            if let closedPrayingSpace = details.closedPrayingSpace {
                ObjectDimensionsRowView(title: S.closedPrayingSpace, value: "\(closedPrayingSpace) m2")
            }
            
            if let maxWorshipersCapacity = details.maxWorshipersCapacity {
                ObjectDimensionsRowView(title: S.maxCapacity, value: "\(maxWorshipersCapacity)")
            }
        }
    }
    
    var mapBoxView: some View {
        ZStack {
            MapBoxDetailView(objectDetails: details, isChangeMapStyleButtonTapped: $isChangeMapStyleButtonTapped)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .cornerRadius(5, corners: .allCorners)
            VStack {
                HStack {
                    
                    Spacer()
                    
                    Button {
                        isChangeMapStyleButtonTapped.toggle()
                    } label: {
                        Img.iconGallery.swiftUIImage
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    var religiousActivityView: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    ReligiousActivityRowView(title: "Sabah:", value: details.sabah)
                    ReligiousActivityRowView(title: "Podne:", value: details.podne)
                    ReligiousActivityRowView(title: "Ikindija:", value: details.ikindija)
                    ReligiousActivityRowView(title: "Akšam:", value: details.aksam)
                    ReligiousActivityRowView(title: "Jacija:", value: details.jacija)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    ReligiousActivityRowView(title: "Džuma:", value: details.dzuma)
                    ReligiousActivityRowView(title: "Teravija:", value: details.teravija)
                    ReligiousActivityRowView(title: "Bajram:", value: details.bayram)
                        .padding(.bottom, 30)
                    ReligiousActivityRowView(title: "Stalni imam:", value: details.permanentImam)
                }
                
                Spacer()
            }
            
            if details.averageNumOfWorshipersDzuma != nil {
                ObjectDimensionsRowView(title: S.worshipersNumber, value: details.averageNumOfWorshipersDzuma)
                    .padding(.trailing, 5)
            } else { }
        }
    }
    
    // MARK: -- Navigation
    var navigationLinks: some View {
        VStack {
            NavigationLink(
                destination: ReportProblemView(object: details),
                tag: NavigationDestination.reportAProblemView,
                selection: $navigationDestination,
                label: { }
            )
        }
        .hidden()
        .frame(width: 0, height: 0)
    }
}
