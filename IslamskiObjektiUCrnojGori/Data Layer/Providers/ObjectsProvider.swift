//
//  ObjectsProvider.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation
import Combine

final class ObjectsProvider {
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func fetchObjectDetails(_ id: Int) -> AnyPublisher<ObjectDetails, Error> {
        let request = APIRequest(endpoint: .getObjectDetails(objectID: id))
        
        guard let urlRequest = try? request.urlRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<ObjectDetailsResponse, Error> in
                self.webService.execute(request)
            }
            .map { $0.message }
            .eraseToAnyPublisher()
    }
    
    func fetchAllObjects() -> AnyPublisher<AllObjects, Error> {
        let request = APIRequest(
            method: .post,
            endpoint: .getAllObjects
        )
    
        guard var urlRequest = try? request.urlRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<AllObjects, Error> in
                self.webService.execute(request)
            }
            .eraseToAnyPublisher()
    }
}
