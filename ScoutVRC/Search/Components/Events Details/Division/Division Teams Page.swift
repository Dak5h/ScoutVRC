//
//  Division Teams Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/10/24.
//

import SwiftUI

struct Division_Teams_Page: View {
    var eventID: Int
    var divID: Int
    
    @StateObject var divRankingsModel = Search_Request()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredTeams(), id: \.self) { team in
                        NavigationLink(destination: Team_Matches_Page(eventID: eventID, teamID: team.team.id, teamNumber: team.team.name, teamName: "")) {
                            VStack(alignment: .leading) {
                                Text("\(team.team.name)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                            }
                            .padding()
                            .listRowBackground(Color.primary.opacity(0.1))
                        }
                    }
                }
                .onAppear {
                    divRankingsModel.getDivisionRankings(eventID: eventID, divID: divID)
                    divRankingsModel.getEventTeams(eventID: eventID)
                }
            }
            .searchable(text: $searchTerm, prompt: "Search for Teams")
        }
    }
    
    // Function to filter and sort teams
    func filteredTeams() -> [EventRanking] {
        let filtered = divRankingsModel.eventRankings.filter { team in
            if searchTerm.isEmpty {
                return true
            } else {
                return team.team.name.contains(searchTerm)
            }
        }
        return filtered.sorted { team1, team2 in
            let parsedTeam1 = parseTeamName(team1.team.name)
            let parsedTeam2 = parseTeamName(team2.team.name)
            
            if parsedTeam1.number == parsedTeam2.number {
                return parsedTeam1.letter < parsedTeam2.letter
            } else {
                return parsedTeam1.number < parsedTeam2.number
            }
        }
    }
    
    // Function to parse team name into numeric and letter parts
    func parseTeamName(_ name: String) -> (number: Int, letter: String) {
        let numberPart = Int(name.dropLast()) ?? 0
        let letterPart = String(name.last ?? " ")
        return (numberPart, letterPart)
    }
}

#Preview {
    Division_Teams_Page(eventID: 51524, divID: 1)
}
