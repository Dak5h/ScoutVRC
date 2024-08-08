//
//  Settings Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Settings_Page: View {
    @State private var username = ""
    @State private var teamNumber = ""
    @State private var newUsername = ""
    @State private var newTeamNumber = ""
    @State private var isLoading = false
    @State private var isEditingUsername = false
    @State private var isEditingTeamNumber = false
    @State private var matchNotificationsEnabled = false
    @State private var chatNotificationsEnabled = false
    
    var body: some View {
        VStack {
            List {
                Section("Profile") {
                    HStack {
                        Text("Current Username:")
                            .font(.headline)
                        Spacer()
                        if isEditingUsername {
                            TextField("Change Username", text: $newUsername)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.headline)
                        } else {
                            Text(username)
                                .foregroundColor(.secondary)
                                .font(.headline)
                        }
                        Button(action: {
                            isEditingUsername.toggle()
                            if !isEditingUsername {
                                saveUsernameChanges()
                            }
                        }) {
                            Image(systemName: isEditingUsername ? "checkmark.circle.fill" : "pencil.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(isEditingUsername ? .red : .secondary)
                        }
                        .padding(.horizontal, 5)
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("Current Team Number:")
                            .font(.headline)
                        Spacer()
                        if isEditingTeamNumber {
                            TextField("Change Team Number", text: $newTeamNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.headline)
                        } else {
                            Text(teamNumber)
                                .foregroundColor(.secondary)
                                .font(.headline)
                        }
                        Button(action: {
                            isEditingTeamNumber.toggle()
                            if !isEditingTeamNumber {
                                saveTeamNumberChanges()
                            }
                        }) {
                            Image(systemName: isEditingTeamNumber ? "checkmark.circle.fill" : "pencil.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(isEditingTeamNumber ? .red : .secondary)
                        }
                        .padding(.horizontal, 5)
                    }
                    .padding(.vertical, 5)
                }
                
//                Section("Notifications (Favorites)") {
//                    Toggle(isOn: $matchNotificationsEnabled) {
//                        Text("Match Notifications")
//                            .font(.headline)
//                    }
//                    .toggleStyle(SwitchToggleStyle(tint: .white))
//                    .onChange(of: matchNotificationsEnabled) {
//                        saveNotificationsChanges()
//                    }
//                    
//                    Toggle(isOn: $chatNotificationsEnabled) {
//                        Text("Message Notifications")
//                            .font(.headline)
//                    }
//                    .toggleStyle(SwitchToggleStyle(tint: .white))
//                    .onChange(of: chatNotificationsEnabled) {
//                        saveNotificationsChanges()
//                    }
//                }
                
                Section("Actions") {
                    Button(action: signOut) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .padding(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                }
            }
        }
        .onAppear {
            fetchUserData()
        }
    }
    
    func fetchUserData() {
        isLoading = true
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let username = document.data()?["username"] as? String {
                    self.username = username
                    self.newUsername = username // Initialize editable field with current username
                }
                if let teamNumber = document.data()?["team number"] as? String {
                    self.teamNumber = teamNumber
                    self.newTeamNumber = teamNumber // Initialize editable field with current team number
                }
                if let matchNotifications = document.data()?["match notifications"] as? Bool {
                    self.matchNotificationsEnabled = matchNotifications
                }
                if let messageNotifications = document.data()?["message notifications"] as? Bool {
                    self.chatNotificationsEnabled = messageNotifications
                }
            } else {
                print("Document does not exist")
            }
            isLoading = false
        }
    }
    
    func saveUsernameChanges() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        if !newUsername.isEmpty {
            userRef.updateData([
                "username": newUsername
            ]) { error in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                } else {
                    print("Username updated successfully")
                    self.username = self.newUsername // Update displayed username
                }
            }
        }
    }
    
    func saveTeamNumberChanges() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        if !newTeamNumber.isEmpty {
            userRef.updateData([
                "team number": newTeamNumber
            ]) { error in
                if let error = error {
                    print("Error updating team number: \(error.localizedDescription)")
                } else {
                    print("Team number updated successfully")
                    self.teamNumber = self.newTeamNumber // Update displayed team number
                }
            }
        }
    }
    
    func saveNotificationsChanges() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData([
            "match notifications": matchNotificationsEnabled,
            "message notifications": chatNotificationsEnabled
        ]) { error in
            if let error = error {
                print("Error updating notifications: \(error.localizedDescription)")
            } else {
                print("Notifications updated successfully")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            // Handle successful sign out (e.g., navigate to login screen)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            // Handle error (e.g., show alert to user)
        }
    }
}

struct Settings_Page_Previews: PreviewProvider {
    static var previews: some View {
        Settings_Page()
    }
}
