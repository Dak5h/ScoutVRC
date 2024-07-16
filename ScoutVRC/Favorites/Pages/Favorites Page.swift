//
//  Favorites Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

// Define the Event model
struct FavoriteEvent: Identifiable, Codable {
    @DocumentID var id: String?
    var eventID: Int
    var name: String
    var start: String
    var end: String
    var eventAddress: String
    var eventSKU: String
    var eventDivisions: [Division]
}

struct FavoriteTeam: Identifiable, Codable {
    @DocumentID var id: String?
    var teamID: Int
    var teamName: String
    var teamNumber: String
}

class FavoritesViewModel: ObservableObject {
    @Published var favoriteEvents = [FavoriteEvent]()
    @Published var favoriteTeams = [FavoriteTeam]()
    
    func fetchFavoriteEvents() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("favorites").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching favorite events: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.favoriteEvents = documents.compactMap { document in
                try? document.data(as: FavoriteEvent.self)
            }
        }
    }
    
    func fetchFavoriteTeams() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("favorites").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching favorite teams: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.favoriteTeams = documents.compactMap { document in
                // Manually create the FavoriteTeam object since the document ID is the teamID
                guard let teamID = Int(document.documentID) else { return nil }
                var team = try? document.data(as: FavoriteTeam.self)
                team?.teamID = teamID
                return team
            }
        }
    }
}

struct Favorites_Page: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section(header: Text("Favorite Events")) {
                    ForEach(viewModel.favoriteEvents) { event in
                        NavigationLink(destination: Event_Home_Page(eventID: event.eventID, eventName: event.name, eventStart: event.start, eventEnd: event.end, eventSKU: event.eventSKU, eventAddress: event.eventAddress, eventDivisions: event.eventDivisions)) {
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
                        }
                    }
                }
                
                Section(header: Text("Favorite Teams")) {
                    ForEach(viewModel.favoriteTeams) { team in
                        NavigationLink(destination: Team_Home_Page(teamID: team.teamID, teamNumber: team.teamNumber, teamName: team.teamName)) {
                            VStack(alignment: .leading) {
                                Text(team.teamNumber)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                
                                Spacer().frame(height: 2)
                                
                                Text(team.teamName)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchFavoriteEvents()
                viewModel.fetchFavoriteTeams()
            }
        }
        .padding(10)
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

struct Favorites_Page_Previews: PreviewProvider {
    static var previews: some View {
        Favorites_Page()
    }
}
