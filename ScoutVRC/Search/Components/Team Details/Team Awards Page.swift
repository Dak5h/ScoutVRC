//
//  Team Awards Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/14/24.
//

import SwiftUI

struct Team_Awards_Page: View {
    var teamID: Int
    
    @StateObject var teamAwardsModel = Search_Request()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(teamAwardsModel.teamAwards, id: \.self) { award in
                        VStack(alignment: .leading) {
                            Text(extractTitleName(award.title))
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            
                            Spacer().frame(height: 2)
                            
                            VStack(alignment: .leading) {
                                Text(award.event.name)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                            }
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.primary.opacity(0.1))
                        }
                    }
                    .padding()
                }
                .onAppear {
                    teamAwardsModel.getTeamAwards(teamID: teamID)
                }
            }
        }
    }
    
    // Function to extract the title name before any parentheses
    func extractTitleName(_ title: String) -> String {
        if let range = title.range(of: " (") {
            return String(title[..<range.lowerBound])
        }
        return title
    }
}

#Preview {
    Team_Awards_Page(teamID: 102409)
}
