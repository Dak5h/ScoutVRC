//
//  RequestWorldSkills.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import Foundation
import Combine

class GetWorldSkillsRankings: ObservableObject {
    @Published var rankings: [SkillsRanking] = []
    
    func fetchHS() {
        guard let url = URL(string: "https://www.robotevents.com/api/seasons/\(seasonID)/skills") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP error: \(response.debugDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let rankings = try JSONDecoder().decode([SkillsRanking].self, from: data)
                
                DispatchQueue.main.async {
                    self?.rankings = rankings
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func fetchMS() {
        guard let url = URL(string: "https://www.robotevents.com/api/seasons/181/skills?grade_level=Middle%20School") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP error: \(response.debugDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let rankings = try JSONDecoder().decode([SkillsRanking].self, from: data)
                
                DispatchQueue.main.async {
                    self?.rankings = rankings
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
