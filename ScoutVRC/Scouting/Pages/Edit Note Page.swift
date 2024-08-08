//
//  Edit Note Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/16/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Edit_Note_Page: View {
    @State private var noteContent: String = ""
    var docID: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextEditor(text: $noteContent)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(height: 400)
                .onTapGesture {
                    // Do nothing to avoid dismissing keyboard when tapping inside the text editor
                }
            
            Button(action: {
                saveNoteContent()
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color.primary.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .onAppear {
            loadNoteContent()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func loadNoteContent() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("notes").document(docID).getDocument { document, error in
            if let error = error {
                print("Error loading note: \(error)")
            } else if let document = document, document.exists {
                let data = document.data()
                noteContent = data?["userNotes"] as? String ?? ""
            }
        }
    }
    
    func saveNoteContent() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("notes").document(docID).updateData([
            "userNotes": noteContent
        ]) { error in
            if let error = error {
                print("Error updating note: \(error)")
            } else {
                print("Note successfully updated")
                UIApplication.shared.endEditing()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    Edit_Note_Page(docID: "zvh3iwkXmitJbqueAZZw")
}
