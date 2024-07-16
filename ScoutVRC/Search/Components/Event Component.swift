//
//  Event Component.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct Event_Component: View {
    @StateObject var eventsModel = Search_Request()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for Events", text: $searchText)
                    .padding(.horizontal, 15)
                    .frame(height: 65)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()

                if searchText.isEmpty {
                    Text("Begin searching for an event to see info")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                
                Spacer().frame(height: 200)
                
                List {
                    Section("Upcoming Events") {
                        if eventsModel.events.isEmpty {
                            Text("No Upcoming Events")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(eventsModel.events, id: \.self) { event in
                                NavigationLink(destination: Event_Home_Page(eventID: event.id, eventName: event.name, eventStart: event.start, eventEnd: event.end, eventSKU: event.sku, eventAddress: "\(event.location.address_1), \(event.location.city), \(event.location.postcode)", eventDivisions: event.divisions)) {
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
                        }
                    }
                }
                .onChange(of: searchText) { newValue in
                    eventsModel.getEvents()
                }
                .onAppear {
                    eventsModel.getEvents()
                }
            }
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
