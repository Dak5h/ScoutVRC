//
//  World Skills Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import Foundation

struct SkillsRanking: Hashable, Decodable {
    let rank: Int
    let team: String
    let teamName: String
    let programming: Int
    let driver: Int
    let eventRegion: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case team
        case scores
    }
    
    enum TeamCodingKeys: String, CodingKey {
        case team
        case teamName
        case eventRegion
    }
    
    enum ScoresCodingKeys: String, CodingKey {
        case programming
        case driver
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        rank = try container.decode(Int.self, forKey: .rank)
        
        let teamContainer = try container.nestedContainer(keyedBy: TeamCodingKeys.self, forKey: .team)
        team = try teamContainer.decode(String.self, forKey: .team)
        teamName = try teamContainer.decode(String.self, forKey: .teamName)
        eventRegion = try teamContainer.decode(String.self, forKey: .eventRegion)
        
        let scoresContainer = try container.nestedContainer(keyedBy: ScoresCodingKeys.self, forKey: .scores)
        programming = try scoresContainer.decode(Int.self, forKey: .programming)
        driver = try scoresContainer.decode(Int.self, forKey: .driver)
    }
}
