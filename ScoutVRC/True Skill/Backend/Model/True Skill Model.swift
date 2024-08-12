//
//  True Skill Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/11/24.
//

import Foundation

struct TrueSkillTeam: Hashable, Decodable {
    let tsRanking: Int?
    let teamNumber: String?
    let teamName: String?
    let trueSkill: Double?
    let totalWins: Double?
    let totalLosses: Double?
    let totalTies: Double?
    let totalWinningPercent: Double?

    enum CodingKeys: String, CodingKey {
        case tsRanking = "ts_ranking"
        case teamNumber = "team_number"
        case teamName = "team_name"
        case trueSkill = "trueskill"
        case totalWins = "total_wins"
        case totalLosses = "total_losses"
        case totalTies = "total_ties"
        case totalWinningPercent = "total_winning_percent"
    }
}
