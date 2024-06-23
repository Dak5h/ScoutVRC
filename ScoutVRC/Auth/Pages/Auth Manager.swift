//
//  Auth Manager.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/14/24.
//

import SwiftUI
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthListener()
    }

    private func setupAuthListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
        }
    }

    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
