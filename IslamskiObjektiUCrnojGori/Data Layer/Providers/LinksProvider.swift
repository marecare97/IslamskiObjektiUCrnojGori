//
//  LinksProvider.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation
import Combine

final class LinksProvider {
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func fetchLinks() -> AnyPublisher<Links, Error> {
        let request = APIRequest(endpoint: .links)
        
        guard let urlRequest = try? request.urlRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<Links, Error> in
                self.webService.execute(request)
            }
            .eraseToAnyPublisher()
    }
}
