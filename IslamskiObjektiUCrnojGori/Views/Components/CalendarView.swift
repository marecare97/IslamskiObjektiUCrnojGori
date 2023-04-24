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
    let calendar = Calendar.current
    let weekDays = ["pon", "uto", "sri", "čet", "pet", "sub", "ned"]
    
    @StateObject var viewModel = ViewModel()
    
    @State var latitude: Double?
    @State var longitude: Double?
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // Go to the previous month
                } label: {
                    Image(systemSymbol: .arrowtriangleLeftFill)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Month Name")
                    .font(RFT.bold.swiftUIFont(size: 18))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button {
                    // Go to the next month
                } label: {
                    Image(systemSymbol: .arrowtriangleRightFill)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .padding(.horizontal, 30)
            
            HStack {
                ForEach(weekDays, id: \.self) { weekday in
                    Text(weekday)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack {
                ForEach(0..<6) { _ in
                    HStack {
                        ForEach(0..<7) { _ in
                            Text("Day")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            print("LAT ======>", latitude)
            print("LONG ======>", longitude)
            viewModel.fetchPrayerTimes(latitude: latitude, longitude: longitude)
        }
    }
}

// MARK: ViewModel
extension CalendarView {
    final class ViewModel: ObservableObject {
        @Published var prayerTimes: [PrayerTimesData] = []
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        
        func fetchPrayerTimes(latitude: Double?, longitude: Double?) {
            guard let url = URL(string: "http://api.aladhan.com/v1/calendar/\(year)/\(month)?latitude=\(latitude)&longitude=\(longitude)")
            else {
                return
            }
            print("CALENDAR URL =====>", url)
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.prayerTimes = decodedResponse.data
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
