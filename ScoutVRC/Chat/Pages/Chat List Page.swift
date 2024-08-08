//
//  Chat Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatThread: Identifiable {
    let id: String
    let name: String
    let lastMessage: String
    let timestamp: Date
    let userIDs: [String]
}

struct Chat_List_Page: View {
    @State private var searchTerm = ""
    @State private var showingNewChatSheet = false
    @State private var selectedThread: ChatThread? = nil
    @State private var isNavigating = false // Add a state to control navigation
    @State private var chatThreads: [ChatThread] = []

    var body: some View {
            VStack {
                List(chatThreads) { thread in
                    Button(action: {
                        selectedThread = thread
                        isNavigating = true
                    }) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(thread.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(formattedDate(thread.timestamp))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Text(thread.lastMessage)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 10)
                    }
                }
 
                NavigationLink(destination: selectedThread.map { Chat_Texting_Page(thread: $0) }, isActive: $isNavigating) {
                    EmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewChatSheet.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showingNewChatSheet) {
                let existingUserIDs = chatThreads.flatMap { $0.userIDs }
                Create_Chat_Component(existingUserIDs: existingUserIDs, onSelectUser: { user in
                    createChatThread(with: user)
                })
            }
            .onAppear {
                fetchChatThreads()
            }
            .onChange(of: isNavigating) { isActive in
                if !isActive {
                    selectedThread = nil
                }
            }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()

        if Calendar.current.isDateInToday(date) {
            formatter.timeStyle = .short
            formatter.dateStyle = .none
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .none
        }

        return formatter.string(from: date)
    }

    private func fetchChatThreads() {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser?.uid ?? ""

        db.collection("chatRooms")
            .whereField("users", arrayContains: currentUserID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching chat threads: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                var threads: [ChatThread] = []

                for document in documents {
                    let data = document.data()
                    let users = data["users"] as? [String] ?? []
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()

                    // Fetch the other user's name (assuming user names are stored in another collection)
                    let otherUserID = users.first { $0 != currentUserID } ?? ""
                    fetchUserName(userID: otherUserID) { userName in
                        let thread = ChatThread(
                            id: document.documentID,
                            name: userName,
                            lastMessage: lastMessage,
                            timestamp: timestamp,
                            userIDs: users // Add the user IDs to the thread
                        )
                        threads.append(thread)

                        // Update the state only once all names are fetched
                        if threads.count == documents.count {
                            chatThreads = threads
                        }
                    }
                }
            }
    }

    private func fetchUserName(userID: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user name: \(error)")
                completion("Unknown")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                let userName = data?["username"] as? String ?? "Unknown"
                completion(userName)
            } else {
                completion("Unknown")
            }
        }
    }

    private func createChatThread(with user: User) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        let chatRoomData: [String: Any] = [
            "users": [currentUserID, user.id],
            "lastMessage": "",
            "timestamp": Timestamp()
        ]

        db.collection("chatRooms").addDocument(data: chatRoomData) { error in
            if let error = error {
                print("Error creating chat room: \(error)")
            } else {
                fetchChatThreads()
            }
        }
    }
}

#Preview {
    Chat_List_Page()
}
