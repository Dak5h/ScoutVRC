//
//  Create Chat Component.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/16/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct User: Identifiable {
    var id: String
    var username: String
    var email: String
    var team: String
    // Add more fields as needed
}

struct Create_Chat_Component: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var users: [User] = []
    var existingUserIDs: [String] // Add a property to hold the existing user IDs
    var onSelectUser: (User) -> Void // Closure to handle user selection

    var body: some View {
        NavigationView {
            VStack {
                List(users) { user in
                    if !existingUserIDs.contains(user.id) {
                        Button(action: {
                            onSelectUser(user)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                    
                                    Spacer().frame(height: 2)
                                    
                                    Text(user.team)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary.opacity(0.75))
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .opacity(0.6)
                            }
                            .padding()
                            .accentColor(.primary)
                            .listRowBackground(Color.primary.opacity(0.1))
                        }
                    }
                }
                
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .onAppear {
                fetchUsersFromFirestore()
            }
        }
    }
    
    private func fetchUsersFromFirestore() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No user is signed in.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                if id == currentUserID {
                    return nil
                }
                let username = data["username"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let team = data["team number"] as? String ?? ""
                return User(id: id, username: username, email: email, team: team)
            }
        }
    }
}
