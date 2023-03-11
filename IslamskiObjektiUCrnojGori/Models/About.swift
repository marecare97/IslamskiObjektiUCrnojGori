//
//  About.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation

struct About: Codable {
    let success: Bool
    let code: Int
    let message: AboutContent
    
    struct AboutContent: Codable {
        let id: Int
        let content: String
    }
}
