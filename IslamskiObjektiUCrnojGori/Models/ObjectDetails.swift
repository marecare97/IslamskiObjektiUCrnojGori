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

struct ObjectDetails: Codable {
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
struct Location: Codable {
    let id: Int
    let key, name: String
}

// MARK: - ObjType
struct ObjType: Codable  {
    let id: Int
    let key, tableKey, name, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, key
        case tableKey = "table_key"
        case name, icon
    }
}
