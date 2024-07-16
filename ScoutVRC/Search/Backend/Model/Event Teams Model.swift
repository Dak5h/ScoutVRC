//
//  Event Teams Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/23/24.
//

import Foundation

struct EventTeamsResponse: Decodable {
    let data: [EventTeam]
}

struct EventTeam: Hashable, Decodable {
    let id: Int
    let number: String
    let team_name: String
}

struct TeamLocation: Hashable, Decodable {
    let venue: String
    let address_1: String
    let city: String
    let region: String?
    let postcode: String
    let country: String
}
 
struct TeamProgram: Hashable, Decodable {
    let id: Int
    let name: String
}
