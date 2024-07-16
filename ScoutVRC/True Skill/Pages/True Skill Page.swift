//
//  True Skill Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct True_Skill_Page: View {
    @StateObject var trueSkillModel = TrueSkill_Request()
    @State private var searchTerm = ""
    
    var filteredTeams: [TrueSkillTeam] {
        if searchTerm.isEmpty {
            return trueSkillModel.trueSkillTeams
        } else {
            return trueSkillModel.trueSkillTeams.filter { team in
                team.team_number.contains(searchTerm) || team.team_name.contains(searchTerm)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(filteredTeams, id: \.self) { team in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(team.ts_ranking). \(team.team_number)")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Text("\(team.team_name)")
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary.opacity(0.5))
                                .lineLimit(1)
                            
                            Spacer()
                            
                            ZStack {
                                Color.clear
                                    .frame(width: 30, height: 30)
                                    .contentShape(Rectangle())
                                    .onTapGesture {}
                                Menu {
                                    Text("True Skill: \(String(format: "%.1f", team.trueskill))")
                                    Text("Winrate: \(String(format: "%.1f", team.total_winning_percent))%")
                                    Text("Record: \(Int(team.total_wins)) - \(Int(team.total_losses)) - \(Int(team.total_ties))")
                                    
                                    Link(destination: URL(string: "https://www.robotevents.com/teams/V5RC/\(team.team_number)")!) {
                                        Label("Team Link", systemImage: "link")
                                    }
                                } label: {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                    .listRowBackground(Color.primary.opacity(0.1))
                }
                .onAppear {
                    trueSkillModel.getTrueSkill()
                }
            }
            .searchable(text: $searchTerm, prompt: "Search for Teams")
        }
    }
}

#Preview {
    True_Skill_Page()
}
