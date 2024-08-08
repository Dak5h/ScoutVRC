//
//  Search Request.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import Foundation
import Combine

var seasonID: Int = 190

class Search_Request: ObservableObject {
    @Published var events: [Event] = []
    @Published var eventDetails: [Event] = []
    @Published var searchedEvents: [SearchedEvent] = []
    @Published var eventTeams: [EventTeam] = []
    @Published var eventSkills: [EventSkills] = []
    @Published var eventAwards: [EventAward] = []
    @Published var eventRankings: [EventRanking] = []
    @Published var eventMatches: [EventMatch] = []
    @Published var teamMatches: [TeamMatch] = []
    
    @Published var searchedTeams: [SearchedTeam] = []
    @Published var teamEvents: [TeamEvent] = []
    @Published var teamAwards: [EventAward] = []
    
    
    private let bearerToken: String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiNzZkNWI5NjQ4MGRkYmE3OTVhNDUwMTczNTQ5MjdjZWIzZjY4ODZhY2QwOGQ1YWJhNzJiMTBkMmQ0YzY3ZDA1NzcxYTUzNGY2ZWJiMTM0ODIiLCJpYXQiOjE2ODc4MjQ1NzUuNjMyNjg4LCJuYmYiOjE2ODc4MjQ1NzUuNjMyNjkyMSwiZXhwIjoyNjM0NTk5Mzc1LjYyOTE1OSwic3ViIjoiMTE2MjI0Iiwic2NvcGVzIjpbXX0.dNtiS0SZbA12j6mGw7VqcSX5YLTuVMWci5YrjUp4v99Svi28C4wcuBifZ3uqpjd0BvgFuZQnpL49HcEVGjkeP0PrwNttQjiRS4MTV0smSih39zAjkYlAakMmI2HBGEto5f41Kfpok9Hjx_wfR-WCv661gWKcTCQ-ZKGEusb8OazyyozFR67HJDl3us_3R0kJouiRwUbKuWqGeZriLFGuMME9Fy0HT0hK36e7mu2yAAzoBGk9OWNrdFiZByqjGAFagOvV4__8F8oLJxE-M5tHqJ0y2TYHWiyeVUXWR4xc-3acptyxDIwV_knAS5QMLwpLuMKSUXaLE3N8-cSVRunA5JAS0M7eowBZ3wnPJ90WooWCD7aFL1IMsYOS6SrwOo1_rlNIgyeXNZ9IVoga1fnApYIXbiQmXJ2tZZYuOwITqtkVdoQT0HMJj_dmBwdqDvtGU44kr3JL17eJoMVCU2Pq5arJ21La8Qrc3Kwb4Sq__w04_kzrEt046UhVQLTPBZJeomBcQE-ptUURbPXHG6OV8NDHWsKH-uKVXFtlDMYxacGQz-5Sji5dD-VgdV5sgYGocVafsj86f2PU8w1BoMI4PetsltWfABmW7ujYRUdornLdXRvB_8Og7Ych5kmwfJkonhPLFaHn6K8WyaFAgAMLpYAjUhiWS58PaP1UR8YhWCM"
    
    func getEvents() {
        events.removeAll()
        
        // Get current date and one week later
        let currentDate = Date()
        let oneWeekLater = Calendar.current.date(byAdding: .day, value: 14, to: currentDate)!
        
        // Format dates as required by the API
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        let start = dateFormatter.string(from: currentDate)
        let end = dateFormatter.string(from: oneWeekLater)
        
        // Create URL with dynamic dates
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events?season[]=\(seasonID)&start=\(start)&end=\(end)&myEvents=false&per_page=250") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let eventsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.events = eventsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getSearchedEvents(searchQuery: String) {
        searchedTeams.removeAll()
        
        guard let url = URL(string: "https://v2.api.vrctracker.blakehaug.com/events?search=\(searchQuery)") else {
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
                let searchedTeamsResponse = try JSONDecoder().decode([SearchedEvent].self, from: data)
                
                DispatchQueue.main.async {
                    self?.searchedEvents = searchedTeamsResponse
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    
    func getEventTeams(eventID: Int) {
        eventTeams.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events/\(eventID)/teams?myTeams=false&per_page=250") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let eventTeamsResponse = try JSONDecoder().decode(EventTeamsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventTeams = eventTeamsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getEventSkills(eventID: Int) {
        eventSkills.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events/\(eventID)/skills?per_page=250") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let eventSkillsResponse = try JSONDecoder().decode(EventSkillsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventSkills = eventSkillsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    var groupedEventSkills: [Int: (teamName: String, rank: Int, driverScore: Int?, driverAttempts: Int, programmingScore: Int?, programmingAttempts: Int)] {
        var result = [Int: (teamName: String, rank: Int, driverScore: Int?, driverAttempts: Int, programmingScore: Int?, programmingAttempts: Int)]()
        
        for skill in eventSkills {
            if result[skill.team.id] == nil {
                result[skill.team.id] = (teamName: skill.team.name, rank: skill.rank, driverScore: nil, driverAttempts: 0, programmingScore: nil, programmingAttempts: 0)
            }
            
            if skill.type == "driver" {
                result[skill.team.id]?.driverScore = skill.score
                result[skill.team.id]?.driverAttempts = skill.attempts
            } else if skill.type == "programming" {
                result[skill.team.id]?.programmingScore = skill.score
                result[skill.team.id]?.programmingAttempts = skill.attempts
            }
        }
        
        return result
    }
    
    func getEventAwards(eventID: Int) {
        eventAwards.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events/\(eventID)/awards") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let eventAwardsResponse = try JSONDecoder().decode(EventAwardsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventAwards = eventAwardsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getDivisionRankings(eventID: Int, divID: Int) {
        eventRankings.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events/\(eventID)/divisions/\(divID)/rankings?per_page=250") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let divRankingsResponse = try JSONDecoder().decode(EventRankingResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventRankings = divRankingsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getDivisionMatches(eventID: Int, divID: Int) {
        eventMatches.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events/\(eventID)/divisions/\(divID)/matches?per_page=250") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let divMatchesResponse = try JSONDecoder().decode(EventMatchResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventMatches = divMatchesResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getTeamMatches(eventID: Int, teamID: Int, completion: @escaping () -> Void) {
        teamMatches.removeAll()
        
        let urlString = "https://www.robotevents.com/api/v2/teams/\(teamID)/matches?event=\(eventID)&per_page=250"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        print("API URL: \(urlString)")
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let teamMatchesResponse = try JSONDecoder().decode(TeamMatchResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.teamMatches = teamMatchesResponse.data
                    completion()
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getTeams(searchQuery: String) {
        searchedTeams.removeAll()
        
        guard let url = URL(string: "https://v2.api.vrctracker.blakehaug.com/teams?search=\(searchQuery)") else {
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
                let searchedTeamsResponse = try JSONDecoder().decode([SearchedTeam].self, from: data)
                
                DispatchQueue.main.async {
                    self?.searchedTeams = searchedTeamsResponse
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getTeamEvents(teamID: Int) {
        teamEvents.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/teams/\(teamID)/events?season=\(seasonID)&per_page=250") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let teamEventsResponse = try JSONDecoder().decode(TeamEventResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.teamEvents = teamEventsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getTeamAwards(teamID: Int) {
        teamAwards.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/teams/\(teamID)/awards?season=\(seasonID)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let teamAwardsResponse = try JSONDecoder().decode(EventAwardsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.teamAwards = teamAwardsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getEventDetails(eventID: Int) {
        eventDetails.removeAll()
        
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events?id=\(eventID)&myEvents=false") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                let eventDetailsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.eventDetails = eventDetailsResponse.data
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
            }
        }
        
        task.resume()
    }
}


