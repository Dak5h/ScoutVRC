//
//  EventAwardsModel.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/8/24.
//

import Foundation

struct EventAwardsResponse: Decodable {
    let data: [EventAward]
}

struct EventAward: Decodable, Hashable {
    let id: Int
    let event: EventDetails
    let order: Int
    let title: String
    let qualifications: [String]
    let designation: String?
    let classification: String?
    let teamWinners: [AwardTeamWinner]
    
    // Conform to Hashable
    static func == (lhs: EventAward, rhs: EventAward) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct EventDetails: Decodable, Hashable {
    let id: Int
    let name: String
    let code: String?
    
    // Conform to Hashable
    static func == (lhs: EventDetails, rhs: EventDetails) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct AwardTeamWinner: Decodable, Hashable {
    let division: DivisionDetails
    let team: AwardTeam
    
    // Conform to Hashable
    static func == (lhs: AwardTeamWinner, rhs: AwardTeamWinner) -> Bool {
        return lhs.division == rhs.division && lhs.team == rhs.team
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(division)
        hasher.combine(team)
    }
}

struct DivisionDetails: Decodable, Hashable {
    let id: Int
    let name: String
    let code: String?
    
    // Conform to Hashable
    static func == (lhs: DivisionDetails, rhs: DivisionDetails) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct AwardTeam: Decodable, Hashable {
    let id: Int
    let name: String
    let code: String?
    
    // Conform to Hashable
    static func == (lhs: AwardTeam, rhs: AwardTeam) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
