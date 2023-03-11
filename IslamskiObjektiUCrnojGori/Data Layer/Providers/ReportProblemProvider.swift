//
//  ReportProblemProvider.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation
import Combine

final class ReportProblemProvider {
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func reportProblem(objectID: Int, email: String, comment: String) -> AnyPublisher<Void, Error> {
        let request = APIRequest(
            method: .post,
            endpoint: .reportProblem,
            body: [
                APIRequest.BodyParameter(key: "isl_object_id", value: objectID),
                APIRequest.BodyParameter(key: "email", value: email),
                APIRequest.BodyParameter(key: "report", value: comment)
            ]
        )
        
        guard var urlRequest = try? request.urlRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        urlRequest.setAuthorization(contentType: "application/json")
        
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<EmptyResponse, Error> in
                self.webService.execute(request)
            }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

struct EmptyResponse: Codable { }
