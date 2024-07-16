//
//  Division Rankings Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/10/24.
//

struct EventRankingResponse: Decodable {
    let data: [EventRanking]
}

struct EventRanking: Hashable, Decodable {
    let id: Int
    let rank: Int
    let team: TeamRankDetails
    let wins: Int
    let losses: Int
    let ties: Int
    let wp: Int
    let ap: Int
    let sp: Int
    let high_score: Int
    let average_points: Double
    let total_points: Int
}

struct TeamRankDetails: Hashable, Decodable {
    let id: Int
    let name: String
    let code: String?
}
