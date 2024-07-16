//
//  Division Tab View.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/10/24.
//

import SwiftUI

struct Division_Tab_View: View {
    var eventID: Int
    var divID: Int
    
    var body: some View {
        TabView {
            Division_Teams_Page(eventID: eventID, divID: divID)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Teams")
                }
            
            Division_Rankings_Page(eventID: eventID, divID: divID)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Rankings")
                }
            
            Division_Matches_Page(eventID: eventID, divID: divID)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Matches")
                }
        }
        .accentColor(.primary)
    }
}

#Preview {
    Division_Tab_View(eventID: 51524, divID: 1)
}
