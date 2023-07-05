//
//  PrayerTimesProvider.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 16.5.23..
//

import Foundation
import CoreLocation

final class PrayersProvider {
    var hasCalledNextPrayerTimeForTomorrow: Bool = false
    
    var dto: PrayersDTO? {
        let decoder = JSONDecoder()
        
        guard
            let url = Bundle.main.url(forResource: "vaktija", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let prayers = try? decoder.decode(PrayersDTO.self, from: data)
        else {
            return nil
        }
        return prayers
    }
    
    public enum Cities: CaseIterable {
        case podgorica, tuzi, bar, ulcinj, pljevlja
        case niksic, budva, tivat, hercegNovi
        case bijeloPolje, plav, gusinje, berane, petnjica, rozaje
        
        var adjustmentTime: Int {
            switch self {
            case .podgorica, .tuzi, .bar, .ulcinj, .pljevlja:
                return 0
            case .niksic, .budva:
                return 1
            case .tivat:
                return 2
            case .hercegNovi:
                return 3
            case .bijeloPolje:
                return -1
            case .plav, .gusinje, .berane, .petnjica:
                return -3
            case .rozaje:
                return -4
            }
        }
        
        var displayName: String {
            switch self {
            case .podgorica:
                return "Podgorica"
            case .tuzi:
                return "Tuzi"
            case .bar:
                return "Bar"
            case .ulcinj:
                return "Ulcinj"
            case .pljevlja:
                return "Pljevlja"
            case .niksic:
                return "Nikšić"
            case .budva:
                return "Budva"
            case .tivat:
                return "Tivat"
            case .hercegNovi:
                return "Herceg Novi"
            case .bijeloPolje:
                return "Bijelo Polje"
            case .plav:
                return "Plav"
            case .gusinje:
                return "Gusinje"
            case .berane:
                return "Berane"
            case .petnjica:
                return "Petnjica"
            case .rozaje:
                return "Rožaje"
            }
        }
        
        var coordinates: CLLocationCoordinate2D {
            switch self {
            case .podgorica:
                return CLLocationCoordinate2D(latitude: 42.4417, longitude: 19.2620)
            case .tuzi:
                return CLLocationCoordinate2D(latitude: 42.3656, longitude: 19.2827)
            case .bar:
                return CLLocationCoordinate2D(latitude: 42.0931, longitude: 19.1005)
            case .ulcinj:
                return CLLocationCoordinate2D(latitude: 41.9265, longitude: 19.2245)
            case .pljevlja:
                return CLLocationCoordinate2D(latitude: 43.3569, longitude: 19.3439)
            case .niksic:
                return CLLocationCoordinate2D(latitude: 42.7731, longitude: 18.9447)
            case .budva:
                return CLLocationCoordinate2D(latitude: 42.2865, longitude: 18.8429)
            case .tivat:
                return CLLocationCoordinate2D(latitude: 42.4364, longitude: 18.6964)
            case .hercegNovi:
                return CLLocationCoordinate2D(latitude: 42.4531, longitude: 18.5322)
            case .bijeloPolje:
                return CLLocationCoordinate2D(latitude: 43.0361, longitude: 19.7467)
            case .plav:
                return CLLocationCoordinate2D(latitude: 42.5964, longitude: 19.9453)
            case .gusinje:
                return CLLocationCoordinate2D(latitude: 42.5631, longitude: 19.8333)
            case .berane:
                return CLLocationCoordinate2D(latitude: 42.8420, longitude: 19.8735)
            case .petnjica:
                return CLLocationCoordinate2D(latitude: 42.9081, longitude: 19.9709)
            case .rozaje:
                return CLLocationCoordinate2D(latitude: 42.8433, longitude: 20.1677)
            }
        }
        
        func findClosestCity(to location: CLLocationCoordinate2D) -> Cities {
            var closestCity: Cities?
            var shortestDistance: CLLocationDistance = Double.infinity
            
            for city in Cities.allCases {
                let cityCoordinates = city.coordinates
                let cityLocation = CLLocation(latitude: cityCoordinates.latitude, longitude: cityCoordinates.longitude)
                let distance = cityLocation.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
                
                if distance < shortestDistance {
                    shortestDistance = distance
                    closestCity = city
                }
            }
            
            return closestCity ?? .podgorica
        }
    }
    
    func getNextPrayerTime(forToday: Bool = true) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/Belgrade")!
        var currentDate: Date {
            if forToday {
                return Date.localDate
            }
            
            let currentDate = Date.localDate
            var dateComponent = DateComponents()
            dateComponent.day = 1
            
            let calendar = calendar
            return calendar.date(byAdding: dateComponent, to: currentDate)!
        }
        
        guard let prayers = dto, let pljevljaIndex = prayers.locations.firstIndex(of: "Pljevlja") else { return nil }
        var monthIndex = calendar.component(.month, from: currentDate)
        var dayIndex = calendar.component(.day, from: currentDate)
        
        monthIndex = monthIndex > 0 ? monthIndex - 1 : monthIndex
        dayIndex = dayIndex > 0 ? dayIndex - 1 : dayIndex
        
        let vaktija = prayers.vaktija.months[monthIndex].days[dayIndex]
        
        let diff = prayers.differences[pljevljaIndex].months[monthIndex].vakat
        
        let startOfTheDay = calendar.startOfDay(for: currentDate).addingTimeInterval(Double(TimeZone.current.secondsFromGMT(for: Date())))
        
        let dates = vaktija.vakat.map {
            let newDate = startOfTheDay.addingTimeInterval(Double($0))
            
            let index = vaktija.vakat.firstIndex(of: $0)!
            
            let readjust = diff[index]
            
            let readjusted = newDate.addingTimeInterval(Double(readjust))
            return readjusted.addingTimeInterval(3600)
        }
        
        let dateToCompare: Date = forToday ? currentDate : startOfTheDay
        
        let futureDates = dates.filter { $0 > dateToCompare }
        
        print("CURRENT DATE \(currentDate)")
        // Find the minimum date in the futureDates array
        if !futureDates.isEmpty {
            print(futureDates)
        }
        let nextDate = futureDates.min()
        return nextDate
    }
    
    
    func getPrayerTimesForCity(_ city: Cities, date: Date = Date()) -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/Belgrade")!
        guard let prayers = dto, let pljevljaIndex = prayers.locations.firstIndex(of: "Pljevlja") else { return [] }
        var monthIndex = calendar.component(.month, from: date)
        var dayIndex = calendar.component(.day, from: date)
        
        monthIndex = monthIndex > 0 ? monthIndex - 1 : monthIndex
        dayIndex = dayIndex > 0 ? dayIndex - 1 : dayIndex
        
        let vaktija = prayers.vaktija.months[monthIndex].days[dayIndex]
        
        let diff = prayers.differences[pljevljaIndex].months[monthIndex].vakat
        
        var startOfTheDay: Date {
            let start = calendar.startOfDay(for: date)
            var components = DateComponents()
            components.setValue(1, for: .hour)
            return calendar.date(byAdding: components , to: start)!
        }
        
        return vaktija.vakat.map {
            let newDate = startOfTheDay.addingTimeInterval(Double($0))
            let index = vaktija.vakat.firstIndex(of: $0)!
            let readjust = diff[index]
            let readjusted = newDate.addingTimeInterval(Double(readjust))
            return readjusted.addingTimeInterval(Double(city.adjustmentTime * 60))
        }
    }
    
}

struct PrayersTimes {
    var months: [Int: [PrayerDay]]
    
    struct PrayerDay {
        let day: Int
        ///seconds from starting the day
        let prayersTimes: [Int]
    }
    
    enum Prayers: String {
        case zora = "Zora"
        case izlazaksunca = "Izlazak sunca"
        case podne = "Podne"
        case ikindija = "Ikindija"
        case akšam = "Akšam"
        case jacija = "Jacija"
    }
}

struct PrayersDTO: Codable {
    let vaktija: Vaktija
    let differences: [Difference]
    let locations, locationsDative, locationsShort, vakatNames: [String]
    let weights: [Int]
}

// MARK: - Difference
struct Difference: Codable {
    let months: [DayElement]
}

// MARK: - DayElement
struct DayElement: Codable {
    let vakat: [Int]
}

// MARK: - Vaktija
struct Vaktija: Codable {
    let months: [VaktijaMonth]
}

// MARK: - VaktijaMonth
struct VaktijaMonth: Codable {
    let days: [DayElement]
}


extension Date {
    static var localDate: Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }
}
