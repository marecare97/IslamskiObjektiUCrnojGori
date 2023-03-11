//
//  Notifications.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation

struct Notifications: Codable {
    let success: Bool
    let code: Int
    let message: [Notification]
    
    struct Notification: Codable, Equatable {
        let id: Int
        let title: String
        let content: String
        let date: String
    }
}
