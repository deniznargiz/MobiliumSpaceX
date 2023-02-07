//
//  QueryResponse.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 7.02.2023.
//

import Foundation

struct QueryResponse : Codable {
    let nextPage: Int?
    let docs: [LaunchResponse]?
    let totalPages: Int?
    let limit: Int?
    let totalDocs: Int?
    let pagingCounter: Int?
    let hasPrevPage: Bool?
    let page: Int?
    let hasNextPage: Bool?
    let prevPage: Int?
}
