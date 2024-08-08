//
//  Chat Texting Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Message: Identifiable, Equatable {
    let id: String
    let content: String
    let isSentByCurrentUser: Bool
    let timestamp: Date
}

struct Chat_Texting_Page: View {
    var thread: ChatThread

    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var chatRoomID: String? = nil

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(messages) { message in
                            HStack {
                                if message.isSentByCurrentUser {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.primary)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                } else {
                                    Text(message.content)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.primary)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .onChange(of: messages) { _ in
                        if let lastMessageId = messages.last?.id {
                            scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                
                Button(action: sendMessage) {
                    Text("Send")
                        .bold()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Chat with \(thread.name)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            chatRoomID = thread.id
            fetchMessages()
        }
    }
    
    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        addMessageToChatRoom()
    }
    
    private func addMessageToChatRoom() {
        guard let chatRoomID = chatRoomID else { return }

        let db = Firestore.firestore()
        let messageData: [String: Any] = [
            "content": newMessage,
            "isSentByCurrentUser": true,
            "timestamp": Timestamp(),
            "senderID": Auth.auth().currentUser!.uid
        ]

        db.collection("chatRooms").document(chatRoomID).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error adding message: \(error)")
            } else {
                newMessage = ""
                fetchMessages()
                updateChatRoomLastMessage()
            }
        }
    }

    private func updateChatRoomLastMessage() {
        guard let chatRoomID = chatRoomID else { return }
        
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        db.collection("chatRooms").document(chatRoomID).updateData([
            "lastMessage": newMessage,
            "timestamp": Timestamp()
        ]) { error in
            if let error = error {
                print("Error updating chat room: \(error)")
            }
        }
    }

    private func fetchMessages() {
        guard let chatRoomID = chatRoomID else { return }
        
        let db = Firestore.firestore()

        db.collection("chatRooms").document(chatRoomID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error loading messages: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }

                self.messages = documents.map { document -> Message in
                    let data = document.data()
                    let content = data["content"] as? String ?? ""
                    let isSentByCurrentUser = data["senderID"] as? String == Auth.auth().currentUser!.uid
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    
                    return Message(id: document.documentID, content: content, isSentByCurrentUser: isSentByCurrentUser, timestamp: timestamp)
                }
            }
    }
}
