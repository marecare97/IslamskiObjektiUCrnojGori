//
//  NotificationsProvider.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation
import Combine

final class NotificationsProvider {
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func fetchNotifications() -> AnyPublisher<Notifications, Error> {
        let request = APIRequest(endpoint: .fetchNotifications)
        
        guard let urlRequest = try? request.urlRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<Notifications, Error> in
                self.webService.execute(request)
            }
            .eraseToAnyPublisher()
    }
}
