//
//  Event Awards Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/8/24.
//
import SwiftUI

struct Event_Awards_Page: View {
    var eventID: Int
    
    @StateObject var eventAwardsModel = Search_Request()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(eventAwardsModel.eventAwards, id: \.self) { award in
                        VStack(alignment: .leading) {
                            Text(extractTitleName(award.title))
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            
                            Spacer().frame(height: 2)
                            
                            ForEach(award.teamWinners, id: \.self) { winner in
                                VStack(alignment: .leading) {
                                    Text(winner.team.name)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .lineLimit(1)
                                }
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                                .listRowBackground(Color.primary.opacity(0.1))
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    eventAwardsModel.getEventAwards(eventID: eventID)
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
    Event_Awards_Page(eventID: 51524)
}
