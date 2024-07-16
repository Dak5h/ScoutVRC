//
//  Search Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct Search_Page: View {
    @State private var selectedSegment = 0
    let segments = ["Events", "Teams"]
    
    var body: some View {
        VStack {
            Picker("Choose an option", selection: $selectedSegment) {
                ForEach(0..<segments.count, id: \.self) { index in
                    Text(segments[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedSegment == 0 {
                Event_Component()
            } else {
                Team_Component()
            }
        }
    }
}

#Preview {
    Search_Page()
}
