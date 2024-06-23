//
//  Event Home Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/22/24.
//

import SwiftUI

struct Event_Home_Page: View {
    var event: Event
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.primary.opacity(0.1))
                    .cornerRadius(10)
                    .frame(height: 225)
                
                VStack {
                    Text(event.name)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .lineLimit(1)
                    
                    Spacer().frame(height: 5)
                    
                    Text("\(formatDate(event.start)) - \(formatDate(event.end))")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundStyle(.primary.opacity(0.5))
                        .lineLimit(1)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    
                    Spacer().frame(height: 35)
                    
                    HStack {
                        Group {
                            VStack {
                                // Number of Teams
                                Text("100")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Teams")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                            
                            VStack {
                                // Number of Divisions
                                Text("12")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("Divisions")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary.opacity(0.5))
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                        }
                        
                        Spacer()
                        
                        Group {
                            // Link to robotevents button
                            Button(action: {}) {
                                Image(systemName: "link")
                                    .frame(maxWidth: .leastNormalMagnitude + 25, maxHeight: .leastNormalMagnitude + 10)
                                    .padding()
                                    .background(Color(#colorLiteral(red: 0.8570463061, green: 0.8669943213, blue: 0.8452582955, alpha: 1)))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .fontWeight(.bold)
                            }
                            
                            // Link to maps button
                            Button(action: {}) {
                                Image(systemName: "location.fill")
                                    .frame(maxWidth: .leastNormalMagnitude + 25, maxHeight: .leastNormalMagnitude + 10)
                                    .padding()
                                    .background(Color(#colorLiteral(red: 0.8570463061, green: 0.8669943213, blue: 0.8452582955, alpha: 1)))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .fontWeight(.bold)
                            }
                        }
                    }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
                }
            }.padding()
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Information")
                    .font(.headline)
                    .foregroundStyle(.primary.opacity(0.6))
                    .padding(.leading, 25)

                List {
                    NavigationLink(destination: Event_Teams_Page()) {
                        Text("Teams")
                    }
                    Text("Skills Rankings")
                    Text("Awards")
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("Divisions")
                    .font(.headline)
                    .foregroundStyle(.primary.opacity(0.6))
                    .padding(.leading, 25)

                List {
                    Text("Division 1")
                    Text("Division 2")
                    Text("Division 3")
                }
            }
            
        }
        .toolbar(.visible, for: .navigationBar)
        .navigationTitle("S C O U T   V R C")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}, label: {
                    Image(systemName: "star")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                })
            }
        }
    }
    
    // Function to format date
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy"
        
        return outputFormatter.string(from: date)
    }
}
