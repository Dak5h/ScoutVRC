//
//  Searched Teams Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/14/24.
//

import Foundation

struct SearchedTeam: Hashable, Decodable {
    let id: Int
    let number: String
    let teamName: String
    let organization: String?
    let grade: String?
    
    enum CodingKeys: String, CodingKey {
        case item
        case id
        case number = "number"
        case teamName = "team_name"
        case organization
        case grade
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let item = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .item)
        
        id = try item.decode(Int.self, forKey: .id)
        number = try item.decode(String.self, forKey: .number)
        teamName = try item.decode(String.self, forKey: .teamName)
        organization = try item.decodeIfPresent(String.self, forKey: .organization)
        grade = try item.decodeIfPresent(String.self, forKey: .grade)
    }
}
