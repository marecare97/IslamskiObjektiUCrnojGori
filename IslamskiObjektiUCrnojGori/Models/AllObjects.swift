//
//  AllObjects.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation

struct AllObjects: Codable {
    let success: Bool
    let code: Int
    let message: [ObjectDetails]
}
