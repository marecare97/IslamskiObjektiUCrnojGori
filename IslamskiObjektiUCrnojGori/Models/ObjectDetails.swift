//
//  ObjectDetails.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation

struct ObjectDetailsResponse: Decodable {
    let success: Bool
    let code: Int
    let message: ObjectDetails
}

struct ObjectDetails: Codable, Identifiable {
    let id, ind: Int
    let name, about: String
    let town, majlis: Location
    let objType: ObjType
    let yearBuilt: Int?
    let yearBuiltText: String?
    let yearRebuilt: String?
    let alternativeNames: String?
    let latitude, longitude, elevation: Double
    let baseDimensions: String?
    let innerDomeHeight: Double?
    let minaretHeight, closedPrayingSpace, maxWorshipersCapacity: Int?
    let dzuma, teravija, bayram, sabah: Bool?
    let podne, ikindija, aksam, jacija: Bool?
    let averageNumOfWorshipersDzuma: Int?
    let permanentImam: Bool?
    let imagesFull: [ImagePath]
    let images: [String]
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id, ind, name, about, town, majlis
        case objType = "obj_type"
        case yearBuilt = "year_built"
        case yearBuiltText = "year_built_text"
        case yearRebuilt = "year_rebuilt"
        case alternativeNames = "alternative_names"
        case latitude, longitude, elevation
        case baseDimensions = "base_dimensions"
        case innerDomeHeight = "inner_dome_height"
        case minaretHeight = "minaret_height"
        case closedPrayingSpace = "closed_praying_space"
        case maxWorshipersCapacity = "max_worshipers_capacity"
        case dzuma, teravija, bayram, sabah, podne, ikindija, aksam, jacija
        case averageNumOfWorshipersDzuma = "average_num_of_worshipers_dzuma"
        case permanentImam = "permanent_imam"
        case imagesFull = "images_full"
        case images, image
    }
}

// MARK: - ImagePath
struct ImagePath: Codable {
    let id: Int
    let name: String
}

// MARK: - Location
struct Location: Codable, Hashable, Equatable {
    let id: Int
    let key, name: String
}

// MARK: - ObjType
struct ObjType: Codable, Hashable, Identifiable, Equatable  {
    let id: Int
    let key, tableKey, name, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, key
        case tableKey = "table_key"
        case name, icon
    }
}

// MARK: - Extension for Array to get unique values
extension Array where Element == ObjectDetails {
    func uniqueValues() -> (towns: [Location], majlises: [Location], yearsBuilt: [Int], objTypes: [ObjType]) {
        var towns = [Location]()
        var majlises = [Location]()
        var yearsBuilt = [Int]()
        var objTypes = [ObjType]()
        
        for object in self {
            towns.append(object.town)
            majlises.append(object.majlis)
            if let yearBuilt = object.yearBuilt {
                yearsBuilt.append(yearBuilt)
            }
            objTypes.append(object.objType)
        }
        
        towns = towns.unique
        majlises  = majlises.unique
        yearsBuilt = yearsBuilt.unique
        objTypes = objTypes.unique
        
        return (towns: towns, majlises: majlises, yearsBuilt: yearsBuilt, objTypes: objTypes)
    }
    
    func filterObjects(towns: [Location]?, majlises: [Location]?, yearBuiltFrom: Int?, yearBuiltTo: Int?, objTypes: [ObjType]?) -> [ObjectDetails] {
           return self.filter { object in
               let matchesTown = towns == nil || towns!.contains(object.town)
               let matchesMajlis = majlises == nil || majlises!.contains(object.majlis)
               let matchesYearBuiltFrom = yearBuiltFrom == nil || (object.yearBuilt ?? Int.min) >= yearBuiltFrom!
               let matchesYearBuiltTo = yearBuiltTo == nil || (object.yearBuilt ?? Int.max) <= yearBuiltTo!
               let matchesObjType = objTypes == nil || objTypes!.contains(object.objType)
               
               return matchesTown || matchesMajlis || matchesYearBuiltFrom || matchesYearBuiltTo || matchesObjType
           }
       }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
