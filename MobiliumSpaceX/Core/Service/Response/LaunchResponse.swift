//
//  LaunchResponse.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import Foundation

struct LaunchResponse: Codable {
    let links: Links?
    let success: Bool?
    let flight_number: Int?
    let name: String?
    let date_utc: String?
    let date_precision: String?
    let upcoming: Bool?
    let cores: [Cores]?
    let id: String?
    
    init(links: Links? = nil,
         success: Bool? = nil,
         flightNumber: Int? = nil,
         name: String? = nil,
         dateUtc: String? = nil,
         datePrecision: String? = nil,
         upcoming: Bool? = nil,
         cores: [Cores]? = nil,
         id: String? = nil) {
        
        self.links = links
        self.success = success
        self.flight_number = flightNumber
        self.name = name
        self.date_utc = dateUtc
        self.date_precision = datePrecision
        self.upcoming = upcoming
        self.cores = cores
        self.id = id
    }
}

struct Links: Codable {
    let patch: Patch?
    let flickr: Flickr?
    let presskit: String?
    let webcast: String?
    let youtubeId: String?
    let article: String?
    let wikipedia: String?
}

struct Cores: Codable {
    let flight: Int?
    let reused, landing_attempt: Bool?
    let landpad: String?
    let core: String?
    let gridfins, legs: Bool?
    let landing_success: Bool?
    let landing_type: String?

}

struct Flickr: Codable {
    let small: [String]?
    let original: [String]?
}

struct Patch: Codable {
    let small: String?
    let large: String?
}
