//
//  Team_Component.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct Team_Component: View {
    @State private var searchText = ""
    @StateObject var teamsModel = Search_Request()
    
    var body: some View {
        VStack {
            TextField("Search for Teams", text: $searchText)
                .padding(.horizontal, 15)
                .frame(height: 65)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            
            if teamsModel.searchedTeams.isEmpty && searchText.isEmpty {
                Text("Begin searching for a team to see info")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding()
            } else {
                List(teamsModel.searchedTeams, id: \.self) { team in
                    NavigationLink(destination: Team_Home_Page(teamID: team.id, teamNumber: team.number, teamName: team.teamName)) {
                        VStack(alignment: .leading) {
                            Text(team.number)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            
                            Spacer().frame(height: 2)
                            
                            Text(team.teamName)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary.opacity(0.5))
                                .lineLimit(1)
                        }
                        .padding()
                        .listRowBackground(Color.primary.opacity(0.1))
                    }
                }
            }
            
            Spacer()
        }
        .onChange(of: searchText) {
            teamsModel.getTeams(searchQuery: $0)
        }
        .onAppear {
            teamsModel.getTeams(searchQuery: searchText)
        }
        .navigationTitle("Teams")
    }
}


struct Team_Component_Previews: PreviewProvider {
    static var previews: some View {
        Team_Component()
    }
}
