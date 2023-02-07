//
//  PastLaunchResponse.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 6.02.2023.
//

import Foundation

struct PastLaunchResponse : Codable {
    let links : Links?
    let success : Bool?
    let flightNumber : Int?
    let name : String?
    let dateUtc : String?
    let datePrecision : String?
    let upcoming : Bool?
    let id : String?
    
    init(links: Links?,
         success: Bool?,
         flightNumber: Int?,
         name: String?,
         dateUtc: String?,
         datePrecision: String?,
         upcoming: Bool?,
         id: String?) {
        self.links = links
        self.success = success
        self.flightNumber = flightNumber
        self.name = name
        self.dateUtc = dateUtc
        self.datePrecision = datePrecision
        self.upcoming = upcoming
        self.id = id
    }
}
