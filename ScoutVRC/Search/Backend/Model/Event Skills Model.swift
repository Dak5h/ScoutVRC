//
//  Event Skills Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/3/24.
//

import Foundation

struct EventSkillsResponse: Decodable {
    let data: [EventSkills]
}

struct EventSkills: Decodable, Hashable {
    let id: Int
    let team: SkillsTeam
    let type: String
    let division: String?
    let rank: Int
    let score: Int
    let attempts: Int

    // Conform to Hashable
    static func == (lhs: EventSkills, rhs: EventSkills) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SkillsTeam: Decodable, Hashable {
    let id: Int
    let name: String
    let code: String?
    
    // Conform to Hashable
    static func == (lhs: SkillsTeam, rhs: SkillsTeam) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
