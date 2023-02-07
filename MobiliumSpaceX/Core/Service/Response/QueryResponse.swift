//
//  QueryResponse.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 7.02.2023.
//

import Foundation

struct QueryResponse : Codable {
    let nextPage : Int?
    let docs : [Doc]?
    let totalPages : Int?
    let limit : Int?
    let totalDocs : Int?
    let pagingCounter : Int?
    let hasPrevPage : Bool?
    let page : Int?
    let hasNextPage : Bool?
    let prevPage : Int?
}

struct Doc: Codable {
    let links: Links?
    let success: Bool?
    let name, dateUtc: String?
    let id: String?
    let cores: [Cores]?
    let flightNumber : Int?
    let datePrecision : String?
    let upcoming : Bool?
    
    // MARK: PAGINATION - pagination da gelen modeli , ilgili launch modele cevirmede kullanilir.
    var launchResponse: LaunchResponse {
        LaunchResponse(
            links: links,
            success: success,
            flightNumber: flightNumber,
            name: name,
            dateUtc: dateUtc,
            datePrecision: datePrecision,
            upcoming: upcoming,
            id: id
        )
    }
    
    var pastLaunchResponse: PastLaunchResponse {
        PastLaunchResponse(
            links: links,
            success: success,
            flightNumber: flightNumber,
            name: name,
            dateUtc: dateUtc,
            datePrecision: datePrecision,
            upcoming: upcoming,
            id: id
        )
    }
}
