//
//  CompositionRoot.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation

final class CompositionRoot {
    static let shared = CompositionRoot()
    
    let webService = NetworkService()
    
    lazy var linksProvider = LinksProvider(webService: webService)
    lazy var aboutProvider = AboutProvider(webService: webService)
    lazy var notificationsProvider = NotificationsProvider(webService: webService)
    lazy var objectsProvider = ObjectsProvider(webService: webService)
    lazy var reportProblemProvider = ReportProblemProvider(webService: webService)
}
