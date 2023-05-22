//
//  VaktijaView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 17.5.23..
//

import SwiftUI

struct VaktijaView: View {
    let prayerTimesProvider = CompositionRoot.shared.prayerTimesProvider
    @State var prayerTimes: [Date] = CompositionRoot.shared.prayerTimesProvider.getPrayerTimesForCity(.podgorica)
    @State var date = Date()
    @State var isAllCitiesBottomSheetPresented = false
    @State private var selectedDropdownIndex: Int?
    
    let prayers = [
        "Sabah",
        "Sunce",
        "Podne",
        "Ikindija",
        "Akšam",
        "Jacija"
    ]
    
    @State var isWidgetPresented: Bool =  UserDefaults.standard.bool(forKey: "islamskiObjekti.isWidgetPresented")
    @State var selectedCity = PrayersProvider.Cities.podgorica
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }
    
    private var startDate: Date {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        return calendar.date(byAdding: .month, value: -1, to: currentDate)!
    }
    
    private var endDate: Date {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        return calendar.date(byAdding: .month, value: 1, to: currentDate)!
    }
    
    private var dates: [Date] {
        let calendar = Calendar.current
        var currentDate = startDate
        var dates = [currentDate]
        
        while currentDate < endDate {
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            dates.append(currentDate)
        }
        
        return dates
    }
    
    func getDayName(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "sr_Latn_RS")
        dateFormatter.dateFormat = "EEE"
        
        let dayString = dateFormatter.string(from: date)
        let firstThreeLettersOfDay = String(dayString.prefix(3))
        return firstThreeLettersOfDay.capitalized
    }
    
    
    var body: some View {
        VStack {
            CustomNavBar(navBarTitle: TK.Vaktija.title)
            contentView
        }
    }
    
    // MARK: Content view
    var contentView: some View {
        VStack {
            
            locationView
            
            datePicker
            
            Spacer()
            
            widgetView
            
            prayerTimesView
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isAllCitiesBottomSheetPresented, content: {
            VStack {
                HStack {
                    Text("Odaberite grad")
                        .font(.system(.headline, weight: .bold))
                    Spacer()
                }
                .padding()
                Divider()
                ScrollView(showsIndicators: false) {
                    allCitiesView
                }
            }
            .presentationDetents([.fraction(0.3)])
        })
        .padding()
        .onChange(of: isWidgetPresented) { newValue in
            UserDefaults.standard.set(newValue, forKey: "islamskiObjekti.isWidgetPresented")
        }
        .onChange(of: date) { newValue in
            prayerTimes = CompositionRoot.shared.prayerTimesProvider.getPrayerTimesForCity(selectedCity, date: newValue)
        }
    }
    
    // MARK: Bottom sheet location view
    var locationView: some View {
        HStack {
            Spacer()
            Img.icLocationGreen.swiftUIImage
                .resizable()
                .frame(width: 15, height: 15)
            
            Text(selectedCity.displayName)
            
            Spacer()
        }
        .scaleEffect(x: 1.5, y: 1.5)
        .onTapGesture {
            isAllCitiesBottomSheetPresented = true
        }
    }
    
    // MARK: Widget view
    var widgetView: some  View {
        HStack {
            Text("Prikaži vidžet na mapi")
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Toggle("", isOn: $isWidgetPresented)
        }
    }
    
    // MARK: Prayer times view
    var prayerTimesView: some View {
        LazyVStack {
            ForEach(prayerTimes, id: \.self) {
                
                let components = Calendar.current.dateComponents([.hour, .minute], from: $0)
                let index = prayerTimes.firstIndex(of: $0)
                VStack {
                    HStack(alignment: .top) {
                        VStack {
                            if let index, let prayer = prayers[index] {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(prayer)
                                            .font(.system(size: 20, weight: .bold))
                                        Image(systemSymbol: selectedDropdownIndex == index ? .chevronUp : .chevronDown)
                                            .resizable()
                                            .frame(width: 12, height: 10)
                                            .font(.system(size: 10, weight: .semibold))
                                        
                                        
                                        Spacer()
                                        
                                        if let hours = components.hour, let minutes = components.minute {
                                            Text(String(format: "%02d", hours))
                                                .font(.system(size: 20, weight: .bold))
                                            + Text(":")
                                                .font(.system(size: 20, weight: .bold))
                                            +  Text(String(format: "%02d", minutes))
                                                .font(.system(size: 20, weight: .bold))
                                        }
                                    }
                                    if selectedDropdownIndex == index {
                                        Button {
                                            // MARK: Push notifications to be implemented
                                        } label: {
                                            ZStack {
                                                Color.green
                                                Text("Podsjeti me")
                                            }
                                            .cornerRadius(20, corners: .allCorners)
                                            .foregroundColor(.white)
                                            .frame(width: 120, height: 40)
                                            .transition(.opacity)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            if selectedDropdownIndex == index {
                                selectedDropdownIndex = nil
                            } else {
                                selectedDropdownIndex = index
                            }
                        }
                    }
                    .padding()
                    
                    Divider()
                }
            }
        }
    }
    
    // MARK: Date picker view
    var datePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                LazyHStack(spacing: 20) {
                    ForEach(dates, id: \.self) { loopDate in
                        ZStack {
                            if Calendar.current.isDate(loopDate, inSameDayAs: date) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 60, height: 60)
                            }
                            VStack(alignment: .center) {
                                Text(getDayName(date: loopDate))
                                
                                Text("\(Calendar.current.component(.day, from: loopDate))")
                                    .font(.headline)
                                + Text(".") +
                                Text("\(Calendar.current.component(.month, from: loopDate))")
                                    .font(.headline)
                                
                            }
                        }
                        .id(Calendar.current.isDate(loopDate, inSameDayAs: date) ? "today" :"\(loopDate)")
                        .onTapGesture {
                            date = loopDate
                            prayerTimes = CompositionRoot.shared.prayerTimesProvider.getPrayerTimesForCity(selectedCity, date: date)
                            scroll(reader: value, id: "\(loopDate)")
                        }
                    }
                }
                .onAppear {
                    scroll(reader: value, id: "today")
                }
                .padding(.horizontal, 20)
            }
            
        }
        
        .padding(.vertical)
        .background(Color.gray.opacity(0.1))
        .scaleEffect(x: 1.1)
    }
    
    // MARK: All cities view
    var allCitiesView: some View  {
        LazyVStack {
            ForEach(PrayersProvider.Cities.allCases, id: \.displayName) { city in
                Button {
                    selectedCity = city
                    isAllCitiesBottomSheetPresented = false
                    prayerTimes = CompositionRoot.shared.prayerTimesProvider.getPrayerTimesForCity(selectedCity, date: date)
                } label: {
                    Text(city.displayName)
                        .padding()
                        .fontWeight(selectedCity == city ? .bold : .regular)
                        .scaleEffect(x: selectedCity == city ? 1.2 : 1, y: selectedCity == city ? 1.2 : 1)
                        .foregroundColor(selectedCity == city ? Color.black : Color.gray)
                }
            }
        }
    }
    
    func scroll(reader: ScrollViewProxy, duration: Double = 0.05, id: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                reader.scrollTo(id, anchor: .center)
            }
        }
    }
}

struct VaktijaView_Previews: PreviewProvider {
    static var previews: some View {
        VaktijaView()
    }
}
