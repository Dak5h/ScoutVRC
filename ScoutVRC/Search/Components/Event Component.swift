//
//  Event Component.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI
struct Event_Component: View {
    @StateObject var eventsModel = Search_Request()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List(eventsModel.events, id: \.self) { event in
                    NavigationLink(destination: Event_Home_Page(event: event)) {
                        VStack(alignment: .leading) {
                            Text(event.name)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .lineLimit(1)

                            Spacer().frame(height: 2)

                            Text("\(formatDate(event.start)) - \(formatDate(event.end))")
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary.opacity(0.5))
                                .lineLimit(1)
                        }
                        .padding()
                        .listRowBackground(Color.primary.opacity(0.1))
                    }
                }
                .onAppear {
                    eventsModel.getEvents()
                }
            }
            .searchable(text: $searchTerm, prompt: "Search for Events")
        }
    }
    
    // Function to format date
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy"
        
        return outputFormatter.string(from: date)
    }
}

#Preview {
    Event_Component()
}

