//
//  Events Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import Foundation

struct EventsResponse: Decodable {
    let data: [Event]
}

struct Event: Hashable, Decodable {
    let id: Int
    let name: String
    let start: String
    let end: String
    let season: Season
    let program: Program
    let location: Location
}

struct Season: Hashable, Decodable {
    let id: Int
    let name: String
}

struct Program: Hashable, Decodable {
    let id: Int
    let name: String
    let code: String
}

struct Location: Hashable, Decodable {
    let venue: String
    let address_1: String
    let address_2: String?
    let city: String
    let region: String?
    let postcode: String
    let country: String
    let coordinates: Coordinates
}

struct Coordinates: Hashable, Decodable {
    let lat: Double
    let lon: Double
}
