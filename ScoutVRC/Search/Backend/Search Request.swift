//
//  Search Request.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import Foundation
import Combine

class Search_Request: ObservableObject {
    @Published var events: [Event] = []
    private let bearerToken: String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiNzZkNWI5NjQ4MGRkYmE3OTVhNDUwMTczNTQ5MjdjZWIzZjY4ODZhY2QwOGQ1YWJhNzJiMTBkMmQ0YzY3ZDA1NzcxYTUzNGY2ZWJiMTM0ODIiLCJpYXQiOjE2ODc4MjQ1NzUuNjMyNjg4LCJuYmYiOjE2ODc4MjQ1NzUuNjMyNjkyMSwiZXhwIjoyNjM0NTk5Mzc1LjYyOTE1OSwic3ViIjoiMTE2MjI0Iiwic2NvcGVzIjpbXX0.dNtiS0SZbA12j6mGw7VqcSX5YLTuVMWci5YrjUp4v99Svi28C4wcuBifZ3uqpjd0BvgFuZQnpL49HcEVGjkeP0PrwNttQjiRS4MTV0smSih39zAjkYlAakMmI2HBGEto5f41Kfpok9Hjx_wfR-WCv661gWKcTCQ-ZKGEusb8OazyyozFR67HJDl3us_3R0kJouiRwUbKuWqGeZriLFGuMME9Fy0HT0hK36e7mu2yAAzoBGk9OWNrdFiZByqjGAFagOvV4__8F8oLJxE-M5tHqJ0y2TYHWiyeVUXWR4xc-3acptyxDIwV_knAS5QMLwpLuMKSUXaLE3N8-cSVRunA5JAS0M7eowBZ3wnPJ90WooWCD7aFL1IMsYOS6SrwOo1_rlNIgyeXNZ9IVoga1fnApYIXbiQmXJ2tZZYuOwITqtkVdoQT0HMJj_dmBwdqDvtGU44kr3JL17eJoMVCU2Pq5arJ21La8Qrc3Kwb4Sq__w04_kzrEt046UhVQLTPBZJeomBcQE-ptUURbPXHG6OV8NDHWsKH-uKVXFtlDMYxacGQz-5Sji5dD-VgdV5sgYGocVafsj86f2PU8w1BoMI4PetsltWfABmW7ujYRUdornLdXRvB_8Og7Ych5kmwfJkonhPLFaHn6K8WyaFAgAMLpYAjUhiWS58PaP1UR8YhWCM"

    func getEvents() {
        guard let url = URL(string: "https://www.robotevents.com/api/v2/events?season[]=181&per_page=250") else {
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
}


