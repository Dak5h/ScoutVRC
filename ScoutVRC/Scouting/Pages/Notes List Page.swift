//
//  Notes List Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/15/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Note: Identifiable {
    let id = UUID()
    var documentID: String
    var name: String
    var description: String
}

struct Notes_List_Page: View {
    @State private var searchText = ""
    @State private var showAddNoteModal = false
    @State private var noteName = ""
    @State private var noteDescription = ""
    @State private var notes = [Note]()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var editNote: Note?

    // Computed property to filter notes based on search text
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    TextField("Search for Notes", text: $searchText)
                        .padding(.horizontal, 15)
                        .frame(height: 65)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding()

                    List {
                        ForEach(filteredNotes) { note in
                            NavigationLink(destination: Edit_Note_Page(docID: note.documentID)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(note.name)
                                            .font(.headline)
                                        Text(note.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    ZStack {
                                        Color.clear
                                            .frame(width: 50, height: 50)
                                            .contentShape(Rectangle())
                                            .onTapGesture {}
                                        Menu {
                                            Button {
                                                editNote = note
                                                noteName = note.name
                                                noteDescription = note.description
                                                showAddNoteModal = true
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }

                                            Button(role: .destructive) {
                                                if let index = notes.firstIndex(where: { $0.id == note.id }) {
                                                    deleteNoteAtOffsets(IndexSet(integer: index))
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis.circle")
                                                .foregroundColor(.primary)
                                                .scaleEffect(1.25)
                                        }
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }

                Button(action: {
                    editNote = nil
                    showAddNoteModal = true
                }) {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding()
            }
            .overlay(
                Group {
                    if showAddNoteModal {
                        ZStack {
                            Color.black.opacity(0.2)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    showAddNoteModal = false
                                }

                            VStack {
                                VStack {
                                    Text(editNote == nil ? "Add New Note" : "Edit Note")
                                        .font(.headline)
                                        .padding()

                                    TextField("Name", text: $noteName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()

                                    TextField("Description (Optional)", text: $noteDescription)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()

                                    Button("Save") {
                                        if !noteName.isEmpty {
                                            if let editNote = editNote {
                                                updateNote(editNote)
                                            } else {
                                                saveNote()
                                            }
                                            showAddNoteModal = false
                                            noteName = ""
                                            noteDescription = ""
                                        } else {
                                            showAlert = true
                                            alertMessage = "Note name cannot be empty."
                                        }
                                    }
                                    .padding()
                                }
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(10)
                                .shadow(radius: 20)
                                .frame(maxWidth: 400)
                            }
                            .padding()
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Validation Error"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }
            )
            .onAppear {
                loadNotes()
            }
        }
    }

    func saveNote() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let note = Note(documentID: "", name: noteName, description: noteDescription)
        let noteData: [String: Any] = [
            "name": note.name,
            "description": note.description,
            "timestamp": Timestamp(),
            "userNotes": ""
        ]

        db.collection("users").document(user.uid).collection("notes").addDocument(data: noteData) { error in
            if let error = error {
                print("Error saving note: \(error)")
            } else {
                loadNotes() // Reload notes to get the latest data including document IDs
            }
        }
    }

    func updateNote(_ note: Note) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let noteData: [String: Any] = [
            "name": noteName,
            "description": noteDescription,
            "timestamp": Timestamp(),
            "userNotes": ""
        ]

        db.collection("users").document(user.uid).collection("notes").document(note.documentID).updateData(noteData) { error in
            if let error = error {
                print("Error updating note: \(error)")
            } else {
                loadNotes() // Reload notes to get the latest data
            }
        }
    }

    func loadNotes() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        db.collection("users").document(user.uid).collection("notes").order(by: "timestamp").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading notes: \(error)")
            } else {
                notes = snapshot?.documents.compactMap { doc -> Note? in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let description = data["description"] as? String else { return nil }
                    return Note(documentID: doc.documentID, name: name, description: description)
                } ?? []
            }
        }
    }

    func deleteNoteAtOffsets(_ offsets: IndexSet) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        offsets.forEach { index in
            let note = notes[index]
            db.collection("users").document(user.uid).collection("notes").document(note.documentID).delete { error in
                if let error = error {
                    print("Error deleting note: \(error)")
                } else {
                    notes.remove(at: index)
                }
            }
        }
    }
}

#Preview {
    Notes_List_Page()
}
