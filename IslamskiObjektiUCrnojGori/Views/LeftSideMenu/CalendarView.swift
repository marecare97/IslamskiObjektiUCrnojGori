//
//  CalendarView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 22.4.23..
//

import SwiftUI
import SFSafeSymbols
import CoreLocation

struct CalendarView: View {
    @StateObject var viewModel = ViewModel()
    @State var toast: Toast.State = .hide
    var islamicCalendar: Calendar {
        var calendar = Calendar(identifier: .islamicUmmAlQura)
        calendar.firstWeekday = 2
        return calendar
    }
    
    var gregorianCalendar: Calendar{
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }
    
    var body: some View {
        VStack {
            CustomNavBar(navBarTitle: TK.LeftSideMenu.calendar)
                .padding(.bottom)
            ScrollView {
                newCalendar
            }
        }
        .toast($toast)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.fetchPrayerTimes()
        }
    }
    
    var newCalendar: some View {
        VStack(alignment: .center) {
            CustomDatePicker(currentDate: $viewModel.date, prayerTimes: $viewModel.prayerTimes)
            
            if let prayerTimes = viewModel.prayerTimes[ViewModel.CalendarTime(month: Calendar.current.component(.month, from: viewModel.date) - 1, year: Calendar.current.component(.year, from: viewModel.date))], let data = prayerTimes.data.first(where: { $0.gregorian.date == getDateToCompareToResponse(date: viewModel.date)
            }) {
                if data.hijri.holidays != [] {
                    LazyVStack {
                        ForEach(data.hijri.holidays, id: \.self) {
                            Text($0)
                                .foregroundColor(.green)
                                .font(.system(.headline, weight: .bold))
                        }
                    }
                    Spacer()
                }
            }
            
            
            HStack {
                Text("Gregorijanski kalendar")
                    .font(FontFamily.Roboto.bold.swiftUIFont(size: 16))
                    .foregroundColor(.black)
                    .padding()
                Spacer()
            }
            
            DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                .labelsHidden()
                .environment(\.calendar, gregorianCalendar)
                .environment(\.locale, Locale(identifier: "sr_Latn"))
                .datePickerStyle(.wheel)
                .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .center)
                .clipped()
                .compositingGroup()
            
            //            Spacer()
        }
        .onChange(of: viewModel.date) { newValue in
            print(getDateToCompareToResponse(date: newValue))
            
            let month = Calendar.current.component(.month, from: newValue) - 1
            let year = Calendar.current.component(.year, from: newValue)
            
            let calendarTime = ViewModel.CalendarTime(month: month, year: year)
            
            if viewModel.prayerTimes[calendarTime] == nil {
                viewModel.fetchPrayerTimes()
            }
        }
    }
    
    func getDateToCompareToResponse(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter.string(from: date)
    }
}

// MARK: ViewModel
extension CalendarView {
    final class ViewModel: ObservableObject {
        struct CalendarTime: Identifiable, Equatable, Hashable {
            var id: String { "\(month), \(year)"}
            let month: Int
            let year: Int
        }
        
        @Published var prayerTimes: [CalendarTime: CalendarResponse.Response] = [:]
        @Published var date = Date()
        
        func fetchPrayerTimes() {
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            
            let calendarTime = CalendarTime(month: month, year: year)
            
            guard prayerTimes[calendarTime] == nil else { return }
            
            guard let url = URL(string: "http://api.aladhan.com/v1/gToHCalendar/\(month)/\(year)")
            else {
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(CalendarResponse.Response.self, from: data)
                        DispatchQueue.main.async {
                            let calendarTime = CalendarTime(month: month, year: year)
                            self.prayerTimes[calendarTime] = decodedResponse
                            let holidays = decodedResponse.data.filter { !$0.hijri.holidays.isEmpty }
                                .map { $0.gregorian.date }
                            print("HOLIDAYS ON ===> \(holidays) ")
                        }
                    } catch let error {
                        print("Failed to decode response: \(error)")
                    }
                } else {
                    print("Fetch failed: \(String(describing: error))")
                }
            }.resume()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    @Binding var prayerTimes: [CalendarView.ViewModel.CalendarTime: CalendarResponse.Response]
    // Month update on arrow button clicks...
    @State var currentMonth: Int = 0
    
    var body: some View {
        
        VStack(spacing: 10){
            
            // Days...
            let days: [String] = ["pon","uto","sri","čet","pet","sub", "ned"]
            
            HStack(spacing: 15){
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Text(extraDate()[1])
                    Text(extraDate()[0])
                }
                .font(RFT.bold.swiftUIFont(size: 16))
                .foregroundColor(.gray)
                .lineLimit(1)
                
                Spacer(minLength: 0)
                
                Button {
                    
                    withAnimation{
                        currentMonth += 1
                    }
                    
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                
            }
            .padding(.horizontal)
            // Day View...
            
            LazyHStack(spacing: 37) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(RFT.bold.swiftUIFont(size: 13))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Dates....
            // Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns,spacing: 15) {
                
                ForEach(extractDate()){value in
                    
                    CardView(value: value)
                        .onTapGesture {
                            if let date = convertIslamicToGregorian(islamicDate: value.date) {
                                currentDate = date
                            }
                        }
                        .isHidden(value.day == -1)
                }
            }
        }
        .onChange(of: currentMonth) { newValue in
            
            // updating Month...
            currentDate = getCurrentMonth()
        }
    }
    
    func convertIslamicToGregorian(islamicDate: Date) -> Date? {
        // Create a Calendar instance corresponding to the Islamic calendar
        let islamicCalendar = Calendar(identifier: .islamic)
        
        // Extract the date components from the Islamic date
        guard let islamicDateComponents = islamicCalendar.dateComponents([.year, .month, .day], from: islamicDate) as DateComponents? else {
            print("Failed to get Islamic date components")
            return nil
        }
        
        // Create a Calendar instance corresponding to the Gregorian calendar
        let gregorianCalendar = Calendar(identifier: .gregorian)
        
        // Convert the Islamic date components to a Gregorian date
        guard let gregorianDate = gregorianCalendar.date(from: islamicDateComponents) else {
            print("Failed to convert Islamic date to Gregorian date")
            return nil
        }
        
        return gregorianDate
    }
    
    func getDateToCompareToResponse(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter.string(from: date)
    }
    
    func hasPrayerTimes(value: DateValue) -> CalendarResponse.DataItem? {
        let calendarTime = CalendarView.ViewModel.CalendarTime(
            month: Calendar.current.component(.month, from: value.date) ,
            year: Calendar.current.component(.year, from: value.date))
        print(calendarTime)
        if let prayerTimes = prayerTimes[calendarTime],
           let prayer = prayerTimes.data.first(where: { $0.gregorian.date == getDateToCompareToResponse(date: value.date) }) {
            return prayer
        }
        return nil
    }
    
    @ViewBuilder
    func CardView(value: DateValue)-> some View {
        VStack {
            if let prayer = hasPrayerTimes(value: value)  {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(isSameDay(islamicUmmAlQuraDate: value.date, gregorianDate: currentDate) ? 1 : !prayer.hijri.holidays.isEmpty ? 0.5 : 0))
                        .frame(width: 35,height: 35)
                    if !prayer.hijri.holidays.isEmpty || isSameDay(islamicUmmAlQuraDate: value.date, gregorianDate: currentDate) {
                        Text("\(value.day)")
                            .font(RFT.medium.swiftUIFont(size: 12))
                            .foregroundColor(.black)
                            .foregroundColor(isSameDay(islamicUmmAlQuraDate: value.date, gregorianDate: currentDate) ? .white : .black)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("\(value.day)")
                            .font(RFT.medium.swiftUIFont(size: 12))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(isSameDay(islamicUmmAlQuraDate: value.date, gregorianDate: currentDate) ? 1 : 0))
                        .frame(width: 35,height: 35)
                    Text("\(value.day)")
                        .font(RFT.medium.swiftUIFont(size: 12))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }
        }
        .padding(.vertical,9)
        .frame(height: 60,alignment: .top)
    }
    
    
    func isSameDay(islamicUmmAlQuraDate: Date, gregorianDate: Date) -> Bool {
        // Create a Calendar instance for each calendar system
        let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
        let gregorianCalendar = Calendar(identifier: .gregorian)
        
        // Convert the Gregorian date to an Islamic date
        let gregorianDateConvertedToIslamic = islamicCalendar.dateComponents([.year, .month, .day], from: gregorianDate)
        
        // Get the year, month, and day components of the Islamic date
        let islamicDateComponents = islamicCalendar.dateComponents([.year, .month, .day], from: islamicUmmAlQuraDate)
        
        // Compare the dates
        return islamicDateComponents == gregorianDateConvertedToIslamic
    }
    
    // checking dates...
    func isSameDay(date1: Date,date2: Date)->Bool{
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // extrating Year And Month for display...
    func extraDate()->[String]{
        
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        let month = calendar.component(.month, from: currentDate) - 1
        let year = calendar.component(.year, from: currentDate)
        
        return ["\(year)",calendar.monthSymbols[month]]
    }
    
    func getCurrentMonth()->Date{
        
        let calendar = Calendar.current
        
        // Getting Current Month Date....
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        
        var calendar = Calendar(identifier: .islamicUmmAlQura)
        calendar.firstWeekday = 2
        
        // Getting Current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentDate.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            let dateValue =  DateValue(day: day, date: date)
            return dateValue
        }
        
        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        if let firstDate = days.first?.date {
            for i in 0..<offsetDays {
                let date = calendar.date(byAdding: .day, value: -i-1, to: firstDate)!
                let day = calendar.component(.day, from: date)
                days.insert(DateValue(day: -1, date: date), at: 0) // -1 for days that are not part of the current month
            }
        }
        
        let lastWeekDay = calendar.component(.weekday, from: days.last?.date ?? Date())
        let remainingDays = (8 - lastWeekDay + calendar.firstWeekday) % 7
        
        if let lastDate = days.last?.date {
            for i in 0..<remainingDays {
                let date = calendar.date(byAdding: .day, value: i+1, to: lastDate)!
                let day = calendar.component(.day, from: date)
                days.append(DateValue(day: -1, date: date)) // -1 for days that are not part of the current month
            }
        }
        
        return days
    }
}


// Extending Date to get Current Month Dates...
extension Date{
    
    func getAllDates()->[Date]{
        
        var calendar = Calendar(identifier: .islamicUmmAlQura)
        calendar.firstWeekday =  2
        
        // getting start Date...
        let startDate = calendar.date(from: Calendar(identifier: .islamicUmmAlQura).dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date...
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar(identifier: .islamicUmmAlQura)) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar(identifier: .islamicUmmAlQura)) -> Int {
        return calendar.component(component, from: self)
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar(identifier: .islamicUmmAlQura).dateComponents([.day], from: date, to: self).day ?? 0
    }
}


struct CalendarResponse: Codable {
    struct Response: Codable {
        let code: Int
        let status: String
        let data: [DataItem]
    }
    
    struct DataItem: Codable {
        let gregorian: Gregorian
        let hijri: Hijri
    }
    
    struct Gregorian: Codable {
        let date: String
        let format: String
        let day: String
        let weekday: Weekday
        let month: Month
        let year: String
        let designation: Designation
    }
    
    struct Hijri: Codable {
        let date: String
        let format: String
        let day: String
        let weekday: Weekday
        let month: Month
        let year: String
        let designation: Designation
        let holidays: [String]
    }
    
    struct Weekday: Codable {
        let en: String
        let ar: String?
    }
    
    struct Month: Codable {
        let number: Int
        let en: String
        let ar: String?
    }
    
    struct Designation: Codable {
        let abbreviated: String
        let expanded: String
    }
}

// Date Value Model...
struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
