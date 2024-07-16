//
//  TrueSkill Request.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 7/11/24.
//

import Foundation
import Combine

class TrueSkill_Request: ObservableObject {
    @Published var trueSkillTeams: [TrueSkillTeam] = []
    
    func getTrueSkill() {
        trueSkillTeams.removeAll()
        
        guard let url = URL(string: "https://vrc-data-analysis.com/v1/allteams") else {
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
                let trueSkillResponse = try JSONDecoder().decode([TrueSkillTeam].self, from: data)
                
                DispatchQueue.main.async {
                    self?.trueSkillTeams = trueSkillResponse
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
