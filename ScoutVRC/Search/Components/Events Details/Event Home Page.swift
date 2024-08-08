//
//  Event_Home_Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/22/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Event_Home_Page: View {
    var eventID: Int
    var eventName: String
    var eventStart: String
    var eventEnd: String
    var eventSKU: String
    var eventAddress: String
    
    @State private var isFavorited = false
    @StateObject var eventSearch = Search_Request()
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.primary.opacity(0.1))
                    .cornerRadius(10)
                    .frame(height: 225)
                
                VStack {
                    Text(eventName)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .lineLimit(1)
                    
                    Spacer().frame(height: 5)
                    
                    Text("\(formatDate(eventStart)) - \(formatDate(eventEnd))")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundStyle(.primary.opacity(0.5))
                        .lineLimit(1)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    
                    Spacer().frame(height: 35)
                    
                    HStack {
                        Group {
                            VStack {
                                // Number of Teams
                                Text(String(eventSearch.eventTeams.count))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Teams")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }

                            VStack {
                                // Number of Divisions
                                Text(String(eventSearch.eventDetails.first?.divisions.count ?? 0))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Divisions")
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
                            Link(destination: URL(string: "https://www.robotevents.com/robot-competitions/vex-robotics-competition/\(eventSKU).html")!) {
                                Image(systemName: "link")
                                    .frame(maxWidth: .leastNormalMagnitude + 25, maxHeight: .leastNormalMagnitude + 10)
                                    .padding()
                                    .background(Color(#colorLiteral(red: 0.8570463061, green: 0.8669943213, blue: 0.8452582955, alpha: 1)))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .fontWeight(.bold)
                            }
                            
                            // Link to maps button
                            Link(destination: URL(string: "http://maps.apple.com/?address=\(eventAddress)")!)
                            {
                                Image(systemName: "location.fill")
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
                Section("Information") {
                    NavigationLink(destination: Event_Teams_Page(eventID: eventID)) {
                        Text("Teams")
                    }
                    
                    NavigationLink(destination: Event_Skills_Page(eventID: eventID)) {
                        Text("Skills Rankings")
                    }
                    
                    NavigationLink(destination: Event_Awards_Page(eventID: eventID)) {
                        Text("Awards")
                    }
                }
                
                Section("Divisions") {
                    ForEach(eventSearch.eventDetails.first?.divisions ?? [], id: \.id) { division in
                        NavigationLink(destination: Division_Tab_View(eventID: eventID, divID: division.id)) {
                            Text(division.name)
                        }
                    }

                }
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
        .onAppear {
            checkIfFavorited()
            eventSearch.getEventTeams(eventID: eventID)
            eventSearch.getEventDetails(eventID: eventID)
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
    
    // Function to add event to favorites
    func addFavoriteEvent(fEventID: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        
        db.collection("users").document(userID).collection("favorites").document(String(fEventID)).setData([
            "eventID": eventID,
            "name": eventName,
            "start": eventStart,
            "end": eventEnd,
            "eventAddress": eventAddress,
            "eventSKU": eventSKU,
        ]) { error in
            if error != nil {
                print("Error adding favorite event: \(error!.localizedDescription)")
            } else {
                isFavorited = true
            }
        }
    }
    
    
    // Function to remove event from favorites
    func removeFavoriteEvent(fEventID: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("favorites").document(String(fEventID)).delete { error in
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
            removeFavoriteEvent(fEventID: eventID)
        } else {
            addFavoriteEvent(fEventID: eventID)
        }
    }
    
    // Function to check if event is already favorited
    func checkIfFavorited() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("favorites").document(String(eventID)).getDocument { (document, error) in
            if let document = document, document.exists {
                isFavorited = true
            } else {
                isFavorited = false
            }
        }
    }
}
