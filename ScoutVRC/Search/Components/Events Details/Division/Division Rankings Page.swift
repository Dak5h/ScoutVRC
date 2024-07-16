//
//  Division Rankings Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/10/24.
//

import SwiftUI

struct Division_Rankings_Page: View {
    var eventID: Int
    var divID: Int
    
    @StateObject var divRankingsModel = Search_Request()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(divRankingsModel.eventRankings.reversed(), id: \.self) { ranking in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(ranking.rank). \(ranking.team.name)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                Text("\(ranking.wins) - \(ranking.losses) - \(ranking.ties)")
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .fontWeight(.bold)
                            }
                            
                            Spacer().frame(height: 15)
                            
                            HStack {
                                    Text("WP: \(ranking.wp)")
                                        .foregroundStyle(.primary.opacity(0.75))
                            
                                Spacer()
                                
                                Text("AP: \(ranking.ap)")
                                        .foregroundStyle(.primary.opacity(0.75))
                                
                                Spacer()
                                
                                Text("SP: \(ranking.sp)")
                                    .foregroundStyle(.primary.opacity(0.75))
                            }
                        }
                        .padding()
                        .listRowBackground(Color.primary.opacity(0.1))
                    }
                }
                .onAppear {
                    divRankingsModel.getDivisionRankings(eventID: eventID, divID: divID)
                }
            }
            .searchable(text: $searchTerm, prompt: "Search for Teams")
        }
    }
}


#Preview {
    Division_Rankings_Page(eventID: 51524, divID: 1)
}
