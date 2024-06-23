//
//  Toggle Pages.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/14/24.
//

import SwiftUI
import Combine

class TogglePages: ObservableObject {
    @Published var isLoginPage: Bool = true
    
    func togglePage() {
        isLoginPage.toggle()
    }
}
