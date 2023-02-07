//
//  Endpoint.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import Foundation

protocol API {
    var url: URL { get }
}

enum Endpoint: RawRepresentable {
    static let baseUrl = "https://api.spacexdata.com/v4"
    case past
    case upcoming
    case query
    case detail(String)
    
    typealias RawValue = String
    
    var rawValue: String {
        switch self {
        case .past:
            return "/launches/past"
        case .upcoming:
            return "/launches/upcoming"
        case .query:
            return "/launches/query"
        case .detail(let id):
            return "/launches/" + id
        }
    }
    
    init?(rawValue: String) {
        return nil
    }
    
}

// MARK: - Endpoints

extension Endpoint: API {
    var url: URL {
        URL(string: Endpoint.baseUrl + self.rawValue)!
    }
}
