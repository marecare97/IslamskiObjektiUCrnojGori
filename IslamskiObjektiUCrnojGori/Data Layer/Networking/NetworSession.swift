//
//  NetworSession.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Nikola Matijevic on 7.3.23..
//

import Foundation
import Combine

protocol NetworkSession {
    func perform(with request: URLRequest) -> AnyPublisher<Data, Error>
}

class DataNetworkSession: NetworkSession {
    private var hasAlreadyFailedWith401 = false
    func perform(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                        throw APIError.unauthenticated
                    } else {
                        if let error =  try? JSONDecoder().decode(ErrorDTO.self, from: data) {
                            throw APIError.unknown(reason: error.message)
                        }
                        throw APIError.dataParseFailed
                    }
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum APIError: Error, Equatable {
    case dataParseFailed
    case unauthenticated
    case unknown(reason: String)
}

struct ErrorDTO: Codable {
    let message: String
}
