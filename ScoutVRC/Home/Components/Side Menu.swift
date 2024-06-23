//
//  Side Menu.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct Side_Menu: View {
    // Checks if menu is showing on screen
    @Binding var isShowing: Bool
    @State private var selectedOption: SideMenuOptionModel?
    @Binding var selectedTab: Int
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        // Side Menu Header
                        Text("S C O U T   V R C")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.title2)
                        
                        Divider()
                        
                        // Side Menu Options
                        Group {
                            VStack {
                                ForEach(SideMenuOptionModel.allCases) { option in
                                    Button(action: {
                                        selectedOption = option
                                        selectedTab = option.rawValue
                                        isShowing = false
                                    }, label: {
                                        Side_Menu_Row(option: option, selectedOption: $selectedOption)
                                    })
                                }
                            }
                        }
                        
                        // Spacing For UI
                        Spacer()
                    }
                    .padding(25)
                    .foregroundColor(.primary)
                    .frame(width: 270, alignment: .leading)
                    .background(colorScheme == .light ? Color.white : Color.black)
                    
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    Side_Menu(isShowing: .constant(true), selectedTab: .constant(0))
}
