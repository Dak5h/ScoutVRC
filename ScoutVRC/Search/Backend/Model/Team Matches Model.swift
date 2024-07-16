//
//  Team Matches Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/14/24.
//

import Foundation

struct TeamMatchResponse: Decodable {
    let data: [TeamMatch]
}

struct TeamMatch: Decodable, Hashable {
    let id: Int
    let matchnum: Int
    let name: String
    let alliances: [MatchAlliance]
}

struct TeamEventDetails: Decodable, Hashable {
    let id: Int
    let name: String
    let code: String
}

struct MatchAlliance: Decodable, Hashable {
    let color: String
    let score: Int
    let teams: [TeamDetails]
}
