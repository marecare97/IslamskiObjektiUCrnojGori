//
//  MosqueTypes.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 16.5.23..
//


import Foundation

struct MosqueTypes: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
}

struct Mosque {
    static let mosqueTypes = [
        MosqueTypes(id: 0, name: "Sabah"),
        MosqueTypes(id: 1, name: "Jacija"),
        MosqueTypes(id: 2, name: "Podne"),
        MosqueTypes(id: 3, name: "Dzuma"),
        MosqueTypes(id: 4, name: "Ikindija"),
        MosqueTypes(id: 5, name: "Teravija"),
        MosqueTypes(id: 6, name: "Akšam"),
        MosqueTypes(id: 7, name: "Bajram")
    ]
}
