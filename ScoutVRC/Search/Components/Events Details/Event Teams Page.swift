//
//  Event Teams Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/23/24.
//

import SwiftUI

struct Event_Teams_Page: View {
    var eventID: Int
    
    @StateObject var eventTeamsModel = Search_Request()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(eventTeamsModel.eventTeams, id: \.self) { team in
                        NavigationLink(destination: Team_Matches_Page(eventID: eventID, teamID: team.id, teamNumber: team.number, teamName: team.team_name)) {
                            VStack(alignment: .leading) {
                                Text("\(team.number)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                
                                Spacer().frame(height: 2)
                                
                                Text("\(team.team_name)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                            }
                        }
                        .padding()
                        .listRowBackground(Color.primary.opacity(0.1))
                    }
                }
                .onAppear {
                    eventTeamsModel.getEventTeams(eventID: eventID)
                }
            }
            .searchable(text: $searchTerm, prompt: "Search for Teams")
        }
    }
}

#Preview {
    Event_Teams_Page(eventID: 51524)
}
