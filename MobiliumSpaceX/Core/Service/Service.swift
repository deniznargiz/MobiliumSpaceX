//
//  Service.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import Foundation
import Alamofire

final class Service {
    typealias ErrorHandler = (Error?) -> ()
    
    func request<T: Decodable, E: API>(api: E, success: @escaping (T) -> (), failure: @escaping ErrorHandler) {
        AF.request(api.url, method: .get).response { result in
            guard let data = result.data, let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
                failure(result.error)
                return
            }
            success(responseModel)
        }
    }
    
    func query<T: Decodable, E: API>(api: E, page: Int, limit: Int = 10, success: @escaping (T) -> (), failure: @escaping ErrorHandler) {
        let parameters: [String : Any] = [
            "options": [
                "limit": limit,
                "page": page,
            ]
        ]
        
        AF.request(api.url, method: .post, parameters: parameters).response { result in
            guard let data = result.data, let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
                failure(result.error)
                return
            }
            success(responseModel)
        }
    }
}
