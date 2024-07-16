//
//  Team Matches Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/13/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Team_Matches_Page: View {
    var eventID: Int
    var teamID: Int
    var teamNumber: String
    var teamName: String
    
    @State private var isFavorited = false
    @StateObject var teamMatchesModel = Search_Request()
    
    @State private var wins = 0
    @State private var losses = 0
    @State private var ties = 0
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.primary.opacity(0.1))
                    .cornerRadius(10)
                    .frame(height: 225)
                
                VStack {
                    Text(teamNumber)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .lineLimit(1)
                    
                    Spacer().frame(height: 5)
                    
                    Text(teamName)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundStyle(.primary.opacity(0.5))
                        .lineLimit(1)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    
                    Spacer().frame(height: 35)
                    
                    HStack {
                        Group {
                            VStack {
                                Text("\(wins)")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Wins")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                            
                            VStack {
                                Text("\(losses)")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Losses")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                            
                            VStack {
                                Text("\(ties)")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Ties")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                        }
                        
                        Spacer()
                        
                        Group {
                            // Link to robotevents button
                            Link(destination: URL(string: "https://www.robotevents.com/teams/V5RC/\(teamNumber)")!) {
                                Image(systemName: "link")
                                    .frame(maxWidth: .leastNormalMagnitude + 25, maxHeight: .leastNormalMagnitude + 10)
                                    .padding()
                                    .background(Color(#colorLiteral(red: 0.8570463061, green: 0.8669943213, blue: 0.8452582955, alpha: 1)))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .fontWeight(.bold)
                            }
                        }
                    }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
                }
            }.padding()
            
            List {
                ForEach(sortedMatches(), id: \.self) { match in
                    VStack(alignment: .leading) {
                        VStack {
                            Text("\(match.name):")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .underline()
                            
                            Spacer()
                            
                            HStack {
                                VStack {
                                    Text("\(match.alliances.first(where: { $0.color == "red" })?.teams[0].team.name ?? "red1")")
                                        .foregroundStyle(.primary.opacity(0.75))
                                        .underline(match.alliances.first(where: { $0.color == "red" })?.teams[0].team.name == teamNumber ? true : false)
                                        .fontWeight(match.alliances.first(where: { $0.color == "red" })?.teams[0].team.name == teamNumber ? .bold : .regular)
                                    
                                    Spacer().frame(height: 5)
                                    
                                    Text("\(match.alliances.first(where: { $0.color == "red" })?.teams[1].team.name ?? "red2")")
                                        .foregroundStyle(.primary.opacity(0.75))
                                        .underline(match.alliances.first(where: { $0.color == "red" })?.teams[1].team.name == teamNumber ? true : false)
                                        .fontWeight(match.alliances.first(where: { $0.color == "red" })?.teams[1].team.name == teamNumber ? .bold : .regular)
                                }
                                
                                Spacer()
                                
                                Text("\(match.alliances.first(where: { $0.color == "red" })?.score ?? 0)")
                                    .foregroundStyle(.red)
                                    .bold()
                                    .font(.system(size: 20))
                                
                                Text(" - ")
                                    .foregroundStyle(.primary)
                                    .bold()
                                    .font(.system(size: 20))
                                
                                Text("\(match.alliances.first(where: { $0.color == "blue" })?.score ?? 0)")
                                    .foregroundStyle(.blue)
                                    .bold()
                                    .font(.system(size: 20))
                                
                                Spacer()
                                
                                VStack {
                                    Text("\(match.alliances.first(where: { $0.color == "blue" })?.teams[0].team.name ?? "blue1")")
                                        .foregroundStyle(.primary.opacity(0.75))
                                        .underline(match.alliances.first(where: { $0.color == "blue" })?.teams[0].team.name == teamNumber ? true : false)
                                        .fontWeight(match.alliances.first(where: { $0.color == "blue" })?.teams[0].team.name == teamNumber ? .bold : .regular)
                                    
                                    Spacer().frame(height: 5)
                                    
                                    Text("\(match.alliances.first(where: { $0.color == "blue" })?.teams[1].team.name ?? "blue2")")
                                        .foregroundStyle(.primary.opacity(0.75))
                                        .underline(match.alliances.first(where: { $0.color == "blue" })?.teams[1].team.name == teamNumber ? true : false)
                                        .fontWeight(match.alliances.first(where: { $0.color == "blue" })?.teams[1].team.name == teamNumber ? .bold : .regular)
                                }
                            }
                        }
                        .padding()
                        .listRowBackground(Color.primary.opacity(0.1))
                    }
                }
            }
            .onAppear {
                print("Fetching team matches for eventID: \(eventID) and teamID: \(teamID)")
                teamMatchesModel.getTeamMatches(eventID: eventID, teamID: teamID) {
                    calculateMatchResults()
                }
                checkIfFavorited()
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .navigationTitle("S C O U T   V R C")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    toggleFavoriteStatus()
                }, label: {
                    Image(systemName: isFavorited ? "star.fill" : "star")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                })
            }
        }
    }
    
    private func sortedMatches() -> [TeamMatch] {
        return teamMatchesModel.teamMatches.sorted(by: { match1, match2 in
            let roundOrder: [String: Int] = ["R16": 1, "QF": 2, "SF": 3, "Final": 4]
            
            // Extract the round part from the name
            let match1RoundName = match1.name.split(separator: " ").first.map(String.init) ?? ""
            let match2RoundName = match2.name.split(separator: " ").first.map(String.init) ?? ""
            
            // Fetch round orders, default to 0 if not found
            let match1Round = roundOrder[match1RoundName] ?? 0
            let match2Round = roundOrder[match2RoundName] ?? 0
            
            // Sort primarily by round order, then by match number
            if match1Round == match2Round {
                return match1.matchnum < match2.matchnum
            }
            
            return match1Round < match2Round
        })
    }
    
    private func calculateMatchResults() {
        var winCount = 0
        var lossCount = 0
        var tieCount = 0
        
        for match in teamMatchesModel.teamMatches {
            let redAlliance = match.alliances.first(where: { $0.color == "red" })
            let blueAlliance = match.alliances.first(where: { $0.color == "blue" })
            
            guard let redScore = redAlliance?.score, let blueScore = blueAlliance?.score else { continue }
            
            let isTeamInRed = redAlliance?.teams.contains(where: { $0.team.name == teamNumber }) ?? false
            let isTeamInBlue = blueAlliance?.teams.contains(where: { $0.team.name == teamNumber }) ?? false
            
            if isTeamInRed || isTeamInBlue {
                if redScore == blueScore {
                    tieCount += 1
                } else if (isTeamInRed && redScore > blueScore) || (isTeamInBlue && blueScore > redScore) {
                    winCount += 1
                } else {
                    lossCount += 1
                }
            }
        }
        
        wins = winCount
        losses = lossCount
        ties = tieCount
    }
    
    
    // Function to add event to favorites
    func addFavoriteTeam(fTeamID: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("favorites").document(String(fTeamID)).setData([
            "teamID": teamID,
            "teamNumber": teamNumber,
            "teamName": teamName
        ]) { error in
            if error != nil {
                print("Error adding favorite event: \(error!.localizedDescription)")
            } else {
                isFavorited = true
            }
        }
    }
    
    
    // Function to remove event from favorites
    func removeFavoriteTeam(fTeamID: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("favorites").document(String(fTeamID)).delete { error in
            if let error = error {
                print("Error removing favorite event: \(error.localizedDescription)")
            } else {
                print("Event successfully removed from favorites!")
                isFavorited = false
            }
        }
    }
    
    // Function to toggle favorite status
    func toggleFavoriteStatus() {
        if isFavorited {
            removeFavoriteTeam(fTeamID: teamID)
        } else {
            addFavoriteTeam(fTeamID: teamID)
        }
    }
    
    // Function to check if event is already favorited
    func checkIfFavorited() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("favorites").document(String(teamID)).getDocument { (document, error) in
            if let document = document, document.exists {
                isFavorited = true
            } else {
                isFavorited = false
            }
        }
    }
}

#Preview {
    Team_Matches_Page(eventID: 51952, teamID: 102409, teamNumber: "295S", teamName: "[PART] S")
}
