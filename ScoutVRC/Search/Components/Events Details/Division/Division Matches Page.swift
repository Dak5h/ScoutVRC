//
//  Division Matches Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/10/24.
//


import SwiftUI

struct Division_Matches_Page: View {
    var eventID: Int
    var divID: Int
    
    @StateObject var divMatchesModel = Search_Request()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            VStack {
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
                                        
                                        Spacer().frame(height: 5)
                                        
                                        Text("\(match.alliances.first(where: { $0.color == "red" })?.teams[1].team.name ?? "red2")")
                                            .foregroundStyle(.primary.opacity(0.75))
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
                                        
                                        Spacer().frame(height: 5)
                                        
                                        Text("\(match.alliances.first(where: { $0.color == "blue" })?.teams[1].team.name ?? "blue2")")
                                            .foregroundStyle(.primary.opacity(0.75))
                                    }
                                }
                            }
                            .padding()
                            .listRowBackground(Color.primary.opacity(0.1))
                        }
                    }
                }
                .onAppear {
                    divMatchesModel.getDivisionMatches(eventID: eventID, divID: divID)
                }
                .searchable(text: $searchTerm, prompt: "Search for Matches")
            }
        }
    }
    
    private func sortedMatches() -> [EventMatch] {
        let filteredMatches = divMatchesModel.eventMatches.filter { searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchTerm) }
        return filteredMatches.sorted(by: { match1, match2 in
            let roundOrder: [String: Int] = ["R16": 1, "QF": 2, "SF": 3, "Final": 4]
            
            // Extract the round part from the name
            let match1RoundName = match1.name.split(separator: " ").first.map(String.init) ?? ""
            let match2RoundName = match2.name.split(separator: " ").first.map(String.init) ?? ""
            
            // Fetch round orders, default to 0 if not found
            let match1Round = roundOrder[match1RoundName] ?? 0
            let match2Round = roundOrder[match2RoundName] ?? 0
            
            return match1Round < match2Round
        })
    }
    
}

#Preview {
    Division_Matches_Page(eventID: 51524, divID: 1)
}
