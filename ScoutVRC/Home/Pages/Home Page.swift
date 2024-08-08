//
//  Home Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct Home_Page: View {
    @State private var showMenu = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TabView(selection: $selectedTab) {
                        Favorites_Page().tag(0)
                        Search_Page().tag(1)
                        World_Skills_Page().tag(2)
                        True_Skill_Page().tag(3)
                        Notes_List_Page().tag(4)
                        Chat_List_Page().tag(5)
                        Settings_Page().tag(6)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
    
                Side_Menu(isShowing: $showMenu, selectedTab: $selectedTab)
            }
            .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
            .navigationTitle("S C O U T   V R C")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                    })
                }
            }
        }
    }
}

#Preview {
    Home_Page()
}
