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
                (team.teamNumber?.lowercased().contains(searchTerm.lowercased()) ?? false) ||
                (team.teamName?.lowercased().contains(searchTerm.lowercased()) ?? false)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for Teams", text: $searchTerm)
                    .padding(.horizontal, 15)
                    .frame(height: 65)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                
                List(filteredTeams, id: \.self) { team in
                    VStack(alignment: .leading) {
                        HStack {
                            if let ranking = team.tsRanking, let number = team.teamNumber {
                                Text("\(ranking). \(number)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                            }
                            
                            Spacer()
                            
                            if let name = team.teamName {
                                Text("\(name)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Color.clear
                                    .frame(width: 30, height: 30)
                                    .contentShape(Rectangle())
                                    .onTapGesture {}
                                Menu {
                                    if let skill = team.trueSkill {
                                        Text("True Skill: \(String(format: "%.1f", skill))")
                                    }
                                    if let winrate = team.totalWinningPercent {
                                        Text("Winrate: \(String(format: "%.1f", winrate))%")
                                    }
                                    if let wins = team.totalWins, let losses = team.totalLosses, let ties = team.totalTies {
                                        Text("Record: \(Int(wins)) - \(Int(losses)) - \(Int(ties))")
                                    }
                                    
                                    if let number = team.teamNumber {
                                        Link(destination: URL(string: "https://www.robotevents.com/teams/V5RC/\(number)")!) {
                                            Label("Team Link", systemImage: "link")
                                        }
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
        }
    }
}

#Preview {
    True_Skill_Page()
}
