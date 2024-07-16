//
//  Side Menu Option Model.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import Foundation

enum SideMenuOptionModel: Int, CaseIterable {
    case favorites
    case search
    case world_skills
    case true_skill
    case scout
    case chat
    case settings
    
    var optionTitle: String {
        switch self {
        case .favorites:
            return "Favorites"
        case .search:
            return "Search"
        case .world_skills:
            return "World Skills"
        case .true_skill:
            return "True Skill"
        case .scout:
            return "Scouting"
        case .chat:
            return "Chat"
        case .settings:
            return "Settings"
        }
    }
    
    var optionImage: String {
        switch self {
        case .favorites:
            return "star.fill"
        case .search:
            return "magnifyingglass.circle.fill"
        case .world_skills:
            return "globe.americas.fill"
        case .true_skill:
            return "chart.bar.xaxis"
        case .scout:
            return "list.bullet.clipboard.fill"
        case .chat:
            return "bubble.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}


extension SideMenuOptionModel: Identifiable {
    var id: Int {return self.rawValue}
}

