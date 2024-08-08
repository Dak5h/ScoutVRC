//
//  World Skills Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI

struct World_Skills_Page: View {
    @StateObject var viewModel = GetWorldSkillsRankings()
    @State private var searchTerm = ""
    @State private var selectedRegion: String = "All Regions"
    @State private var selectedGradeLevel: String = "High School"
    @State private var regions: [String] = ["All Regions"]
    private var gradeLevels = ["High School", "Middle School"]
    @Environment(\.colorScheme) var colorScheme

    private var filteredRankings: [SkillsRanking] {
        var results = viewModel.rankings
        if !searchTerm.isEmpty {
            results = results.filter { $0.team.localizedCaseInsensitiveContains(searchTerm) }
        }
        if selectedRegion != "All Regions" {
            results = results.filter { $0.eventRegion == selectedRegion }
        }
        return results
    }

    private func fetchRankings() {
        if selectedGradeLevel == "High School" {
            viewModel.fetchHS()
        } else {
            viewModel.fetchMS()
        }
    }

    private func fetchRegions() {
        let uniqueRegions = Set(viewModel.rankings.map { $0.eventRegion })
        regions = ["All Regions"] + uniqueRegions.sorted()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TextField("Search for Teams", text: $searchTerm)
                        .padding(.horizontal, 15)
                        .frame(height: 65)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                        .onChange(of: searchTerm) {
                            // Trigger update on search term change
                        }

                    HStack {
                        Menu {
                            ForEach(regions, id: \.self) { region in
                                Button(action: {
                                    selectedRegion = region
                                }) {
                                    Text(region)
                                }
                            }
                        } label: {
                            Text(selectedRegion)
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                                .accentColor(.primary)
                        }

                        Spacer()

                        Menu {
                            ForEach(gradeLevels, id: \.self) { gradeLevel in
                                Button(action: {
                                    selectedGradeLevel = gradeLevel
                                    fetchRankings()
                                }) {
                                    Text(gradeLevel)
                                }
                            }
                        } label: {
                            Text(selectedGradeLevel)
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                                .accentColor(.primary)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 45, bottom: 0, trailing: 45))

                    List(filteredRankings, id: \.self) { ranking in
                        VStack(alignment: .leading) {
                            Text("\(ranking.rank). \(ranking.team)")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

                            Spacer().frame(height: 2)

                            Text("\(ranking.teamName)")
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary.opacity(0.5))

                            Spacer().frame(height: 10)

                            HStack {
                                Text("Prog: \(ranking.programming)")
                                    .foregroundStyle(.primary.opacity(0.75))

                                Spacer()

                                Text("Driver: \(ranking.driver)")
                                    .foregroundStyle(.primary.opacity(0.75))

                                Spacer()

                                Text("Total: \(ranking.driver + ranking.programming)")
                                    .foregroundStyle(.primary.opacity(0.75))
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .listRowBackground(Color.primary.opacity(0.1))
                    }
                    .onAppear {
                        fetchRankings()
                    }
                    .onChange(of: viewModel.rankings) { _, _ in
                        fetchRegions()
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

#Preview {
    World_Skills_Page()
}
