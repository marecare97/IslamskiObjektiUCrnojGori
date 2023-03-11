//
//  APIRequest.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//
import Foundation

struct APIRequest {
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
    }
    
    private let baseURL: String = "https://vakufi.me/api"
    
    let method: Method
    let endpoint: Endpoint
    let httpBody: [BodyParameter]
    let headers: [URLRequest.Headers: String]
    
    struct BodyParameter: Equatable {
        let key: String
        let value: AnyHashable
    }
    
    /// Initialises APIRequest object
    /// - Parameters:
    ///   - method: HTTP Method, defaults to GET
    init(
        method: Method = .get,
        endpoint: Endpoint,
        body: [BodyParameter] = [],
        headers: [URLRequest.Headers: String] = [:]
    ) {
        self.method = method
        self.endpoint = endpoint
        self.httpBody = body
        self.headers = headers
    }
    
    func urlRequest() throws -> URLRequest {
        let urlString = baseURL + "/" + endpoint.path + endpoint.parameters
        guard let url = URL(string: urlString) else {
            throw APIRequestError.urlMalformed
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        if !httpBody.isEmpty {
            let body = try? JSONSerialization.data(withJSONObject: httpBody.convertToDictionary())
            request.httpBody = body
        }
        
        if !headers.isEmpty {
            headers.forEach { header in
                request.setValue(header.value, forHTTPHeaderField: header.key.rawValue)
            }
        }
        return request
    }
}

extension APIRequest {
    enum Endpoint {
        case links
        case aboutTheApp
        case fetchNotifications
        case reportProblem
        case getAllObjects
        case getObjectDetails(objectID: Int)
        
        var path: String {
            switch self {
            case .links:
                return "links"
            case .aboutTheApp:
                return "about"
            case .fetchNotifications:
                return "notifications"
            case .reportProblem:
                return "report"
            case .getAllObjects:
                return "objects/200/1"
            case .getObjectDetails(let objectID):
                return "object/\(objectID)"
            }
        }
        
        var parameters: String { "" }
    }
}

enum APIRequestError: Error {
    case urlMalformed
    case bodyDataMalformed
}

extension Array where Element == APIRequest.BodyParameter {
    func convertToDictionary() -> [String: AnyHashable] {
        var dict = [String: AnyHashable]()
        self.map {
            dict[$0.key] = $0.value
        }
        return dict
    }
}

enum URLError: Error {
    case urlMalformed
}
