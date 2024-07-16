//
//  Team Events Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/14/24.
//

import Foundation

struct TeamEventResponse: Decodable {
    let data: [TeamEvent]
}

struct TeamEvent: Decodable, Hashable {
    let id: Int
    let sku: String
    let name: String
    let start: String
    let end: String
    let location: Location
    let divisions: [Division]

    struct Season: Decodable, Hashable {
        let id: Int
        let name: String
        let code: String?
    }

    struct Program: Decodable, Hashable {
        let id: Int
        let name: String
        let code: String
    }

    struct Location: Decodable, Hashable {
        let venue: String
        let address_1: String?
        let city: String
        let region: String
        let postcode: String
        let country: String
    }
}
