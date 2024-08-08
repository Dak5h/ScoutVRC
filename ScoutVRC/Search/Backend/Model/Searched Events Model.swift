import Foundation

struct SearchedEvent: Hashable, Decodable {
    let id: Int
    let sku: String
    let name: String
    let start: String
    let end: String
    let seasonId: String
    let programId: String
    let level: String
    let ongoing: Bool
    let awardsFinalized: Bool
    let eventType: String
    let locationVenue: String
    let locationAddress1: String
    let locationAddress2: String?
    let locationCity: String
    let locationRegion: String
    let locationPostcode: String
    let locationCountry: String
    let locationCoordinatesLat: String
    let locationCoordinatesLon: String
    
    private enum CodingKeys: String, CodingKey {
        case id, sku, name, start, end, seasonId, programId, level, ongoing, awardsFinalized = "awards_finalized", eventType = "event_type"
        case locationVenue = "locationVenue"
        case locationAddress1 = "locationAddress1"
        case locationAddress2 = "locationAddress2"
        case locationCity = "locationCity"
        case locationRegion = "locationRegion"
        case locationPostcode = "locationPostcode"
        case locationCountry = "locationCountry"
        case locationCoordinatesLat = "locationCoordinatesLat"
        case locationCoordinatesLon = "locationCoordinatesLon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        sku = try container.decode(String.self, forKey: .sku)
        name = try container.decode(String.self, forKey: .name)
        start = try container.decode(String.self, forKey: .start)
        end = try container.decode(String.self, forKey: .end)
        seasonId = try container.decode(String.self, forKey: .seasonId)
        programId = try container.decode(String.self, forKey: .programId)
        level = try container.decode(String.self, forKey: .level)
        
        let ongoingString = try container.decode(String.self, forKey: .ongoing)
        ongoing = ongoingString == "true"
        
        let awardsFinalizedString = try container.decode(String.self, forKey: .awardsFinalized)
        awardsFinalized = awardsFinalizedString == "true"
        
        eventType = try container.decode(String.self, forKey: .eventType)
        locationVenue = try container.decode(String.self, forKey: .locationVenue)
        locationAddress1 = try container.decode(String.self, forKey: .locationAddress1)
        locationAddress2 = try container.decodeIfPresent(String.self, forKey: .locationAddress2)
        locationCity = try container.decode(String.self, forKey: .locationCity)
        locationRegion = try container.decode(String.self, forKey: .locationRegion)
        locationPostcode = try container.decode(String.self, forKey: .locationPostcode)
        locationCountry = try container.decode(String.self, forKey: .locationCountry)
        locationCoordinatesLat = try container.decode(String.self, forKey: .locationCoordinatesLat)
        locationCoordinatesLon = try container.decode(String.self, forKey: .locationCoordinatesLon)
    }
}
