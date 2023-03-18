//
//  NetworkService.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//


import Foundation
import Combine

protocol WebService {
    func execute<D>(_ request: URLRequest) -> AnyPublisher<D, Error> where D : Decodable
}

class NetworkService: WebService {
    private let networkSession: NetworkSession
    private let decoder: JSONDecoder

    init(
        decoder: JSONDecoder = JSONDecoder(),
        networkSession: NetworkSession = DataNetworkSession()
    ) {
        self.decoder = decoder
        self.networkSession = networkSession
    }

    func execute<D>(_ request: URLRequest) -> AnyPublisher<D, Error> where D : Decodable {
        
        return networkSession.perform(with: request)
            .decode(type: D.self, decoder: decoder)
            .mapError { error in
                if let error = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch error {
                    case .dataCorrupted(let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    return APIError.unknown(reason: errorToReport)
                }  else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
}

extension URLRequest {
    enum Headers: String {
        case accept = "Accept"
        case contentType = "Content-Type"
    }
}

public extension URLRequest {
    mutating func setAuthorization(contentType: String) {
        self.setValue("*/*", forHTTPHeaderField: URLRequest.Headers.accept.rawValue)
        self.setValue(contentType, forHTTPHeaderField: URLRequest.Headers.contentType.rawValue)
    }
}
