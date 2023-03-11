//
//  AboutProvider.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation
import Combine

final class AboutProvider {
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func fetchAbout() -> AnyPublisher<About, Error> {
        let request = APIRequest(endpoint: .aboutTheApp)
        
        guard let urlRequest = try? request.urlRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<About, Error> in
                self.webService.execute(request)
            }
            .eraseToAnyPublisher()
    }
}
