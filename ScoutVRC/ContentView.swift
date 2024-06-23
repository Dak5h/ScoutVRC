//
//  ContentView.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    // Classes
    @StateObject private var togglePages = TogglePages()
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        VStack {
            Group {
                if authManager.isAuthenticated {
                    Home_Page()
                } else {
                    if togglePages.isLoginPage {
                        Login_Page(togglePages: togglePages)
                    } else {
                        Register_Page(togglePages: togglePages)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
