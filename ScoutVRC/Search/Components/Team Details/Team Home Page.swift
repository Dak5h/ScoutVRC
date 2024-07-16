//
//  Team Home Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/14/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Team_Home_Page: View {
    var teamID: Int
    var teamNumber: String
    var teamName: String
    
    @State private var isFavorited = false
    @StateObject var teamEventsModel = Search_Request()
    
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
                    
                    HStack(alignment: .top) {
                        Group {
                            VStack {
                                Text(String(teamEventsModel.teamEvents.count))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Events")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                            
                            VStack {
                                Text(String(teamEventsModel.teamAwards.count))
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Awards")
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
                Section("Information") {
                    NavigationLink(destination: Team_Awards_Page(teamID: teamID)) {
                            Text("Awards")
                        }
                }
                
                Section("Events") {
                    ForEach(teamEventsModel.teamEvents, id: \.id) { event in
                        NavigationLink(destination: Event_Home_Page(eventID: event.id, eventName: event.name, eventStart: event.start, eventEnd: event.end, eventSKU: event.sku, eventAddress: "\(String(describing: event.location.address_1)),\(event.location.city),\(event.location.postcode)", eventDivisions: event.divisions)) {
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
        .onAppear {
            checkIfFavorited()
            teamEventsModel.getTeamEvents(teamID: teamID)
            teamEventsModel.getTeamAwards(teamID: teamID)
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
    Team_Home_Page(teamID: 102409, teamNumber: "295S", teamName: "[PART] S")
}
