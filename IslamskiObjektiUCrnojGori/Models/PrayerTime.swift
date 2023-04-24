//
//  PrayerTime.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 22.4.23..
//

import Foundation

struct PrayerTimesResponse: Codable {
    let code: Int
    let status: String
    let data: [PrayerTimesData]
}

struct PrayerTimesData: Codable {
    let timings: PrayerTimings
    let date: PrayerDate
    let meta: PrayerMeta
}

struct PrayerTimings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Sunset: String
    let Maghrib: String
    let Isha: String
    let Imsak: String
    let Midnight: String
    let Firstthird: String
    let Lastthird: String
}

struct PrayerDate: Codable {
    let readable: String
    let timestamp: String
    let gregorian: GregorianDate
    let hijri: HijriDate
}

struct GregorianDate: Codable {
    let date: String
    let format: String
    let day: String
    let weekday: GregorianWeekday
    let month: GregorianMonth
    let year: String
    let designation: Designation
}

struct GregorianWeekday: Codable {
    let en: String
}

struct GregorianMonth: Codable {
    let number: Int
    let en: String
}

struct HijriDate: Codable {
    let date: String
    let format: String
    let day: String
    let weekday: HijriWeekday
    let month: HijriMonth
    let year: String
    let designation: Designation
    let holidays: [String]
}

struct HijriWeekday: Codable {
    let en: String
    let ar: String
}

struct HijriMonth: Codable {
    let number: Int
    let en: String
    let ar: String
}

struct Designation: Codable {
    let abbreviated: String
    let expanded: String
}

struct PrayerMeta: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let method: PrayerMethod
    let latitudeAdjustmentMethod: String
    let midnightMode: String
    let school: String
    let offset: PrayerOffset
}

struct PrayerMethod: Codable {
    let id: Int
    let name: String
    let params: PrayerParams
    let location: PrayerLocation
}

struct PrayerParams: Codable {
    let Fajr: Int
    let Isha: Int
}

struct PrayerLocation: Codable {
    let latitude: Double
    let longitude: Double
}

struct PrayerOffset: Codable {
    let Imsak: Int
    let Fajr: Int
    let Sunrise: Int
    let Dhuhr: Int
    let Asr: Int
    let Maghrib: Int
    let Sunset: Int
    let Isha: Int
    let Midnight: Int
}
