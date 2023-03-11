//
//  Links.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation

struct Links: Codable {
    let success: Bool
    let code: Int
    let message: [Link]
    
    struct Link: Codable, Equatable {
        let id: Int
        let title: String
        let url: String
        enum CodingKeys: String, CodingKey {
            case id, title, url
        }
    }
}
