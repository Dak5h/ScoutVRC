//
//  Side Menu Row.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct Side_Menu_Row: View {
    let option: SideMenuOptionModel
    @Binding var selectedOption: SideMenuOptionModel?
    
    private var isSelected: Bool {
        return selectedOption == option
    }
    
    var body: some View {
        HStack {
            Image(systemName: option.optionImage)
                .imageScale(.small)
            
            Text(option.optionTitle)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.leading)
        .frame(width: 216, height: 54)
        .background(isSelected ? .white.opacity(0.25) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    Side_Menu_Row(option: .favorites, selectedOption: .constant(.favorites))
}
