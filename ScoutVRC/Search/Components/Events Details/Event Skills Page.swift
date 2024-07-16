//
//  Event Skills Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/2/24.
//

import SwiftUI

struct Event_Skills_Page: View {
    var eventID: Int
    
    @StateObject var eventSkillsModel = Search_Request()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Sort team IDs by rank descending
                    let sortedTeamIDs = eventSkillsModel.groupedEventSkills.keys.sorted(by: { (teamID1, teamID2) in
                        eventSkillsModel.groupedEventSkills[teamID1]?.rank ?? 0 < eventSkillsModel.groupedEventSkills[teamID2]?.rank ?? 0
                    })
                    
                    ForEach(sortedTeamIDs, id: \.self) { teamID in
                        if let teamScores = eventSkillsModel.groupedEventSkills[teamID] {
                            VStack(alignment: .leading) {
                                Text("\(teamScores.rank). \(teamScores.teamName)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                Spacer().frame(height: 10)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Prog: \(teamScores.programmingScore ?? 0)")
                                            .foregroundStyle(.primary.opacity(0.75))
                                            .fontWeight(.semibold)
                                        
                                        Spacer().frame(height: 2)
                                        
                                        Text("Runs: \(teamScores.programmingAttempts)")
                                            .foregroundStyle(.primary.opacity(0.75))
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading) {
                                        Text("Driver: \(teamScores.driverScore ?? 0)")
                                            .foregroundStyle(.primary.opacity(0.75))
                                            .fontWeight(.semibold)
                                        
                                        Spacer().frame(height: 2)
                                        
                                        Text("Runs: \(teamScores.driverAttempts)")
                                            .foregroundStyle(.primary.opacity(0.75))
                                    }
    
                                    
                                    Text("Total: \((teamScores.programmingScore ?? 0) + (teamScores.driverScore ?? 0))")
                                        .foregroundStyle(.primary.opacity(0.75))
                                        .fontWeight(.bold)
                                }
                            }
                            .padding()
                            .listRowBackground(Color.primary.opacity(0.1))
                        }
                    }
                }
                .onAppear {
                    eventSkillsModel.getEventSkills(eventID: eventID)
                }
            }
            .searchable(text: $searchTerm, prompt: "Search for Teams")
        }
    }
}

#Preview {
    Event_Skills_Page(eventID: 51524)
}
