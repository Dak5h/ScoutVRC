//
//  Division Matches Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/11/24.
//

import Foundation

struct EventMatchResponse: Decodable {
    let data: [EventMatch]
}

struct EventMatch: Decodable, Hashable {
    let id: Int
    let name: String
    let alliances: [Alliance]
}

struct Alliance: Decodable, Hashable {
    let color: String
    let score: Int
    let teams: [TeamDetails]
}

struct TeamDetails: Decodable, Hashable {
    let team: Team
}

struct Team: Decodable, Hashable {
    let id: Int
    let name: String
}
