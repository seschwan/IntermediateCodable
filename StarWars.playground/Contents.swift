import UIKit

struct Person: Codable { // Decodable
    let name: String
    let height: Int
    let hairColor: String
    
    let films: [URL]
    let vehicles: [URL]
    let starships: [URL]
    
    
    enum PersonKeys: String, CodingKey {
        case name
        case height
        case hairColor = "hair_color"
        case films
        case vehicles
        case starships
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        self.hairColor = try container.decode(String.self, forKey: .hairColor)
        
        let heightString = try container.decode(String.self, forKey: .height)
        self.height = Int(heightString) ?? 0
        
        // Films -> Approach 1
        
        var filmContainer = try container.nestedUnkeyedContainer(forKey: .films)
        var filmURLs: [URL] = []
        while filmContainer.isAtEnd == false {
            let filmString = try filmContainer.decode(String.self)
            if let filmURL = URL(string: filmString) {
                filmURLs.append(filmURL)
            }
        }
        self.films = filmURLs
        
        // Vehicles -> Approach #2
        let vehiclesStrings = try container.decode([String].self, forKey: .vehicles)
        self.vehicles = vehiclesStrings.compactMap {URL(string: $0) }
        
        // Starships -> Approach # 3 to decoding an array of URLs
        self.starships = try container.decode([URL].self, forKey: .starships)
        
        func encode(with encoder: Encoder) throws {
            var container = encoder.container(keyedBy: PersonKeys.self)
            // Name
            try container.encode(self.name, forKey: .name)
            // HairColor
            try container.encode(self.hairColor, forKey: .hairColor)
            // Height
            try container.encode("\(height)", forKey: .height)
            
            // Films #1
            var filmsContainer = container.nestedUnkeyedContainer(forKey: .films)
            for filmURL in films {
                try filmsContainer.encode(filmURL.absoluteString)
            }
            
            // Vehicles #2
            let vehicleStrings = vehicles.map { $0.absoluteString }
            try container.encode(vehiclesStrings, forKey: .vehicles)
            
            // StarShips #3
            try container.encode(starships, forKey: .starships)
            
        }
    }
}
let url = URL(string: "https://swapi.co/api/people/1/")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let luke = try! decoder.decode(Person.self, from: data)


// Encoder
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted]
let lukeData = try! encoder.encode(luke)

let lukeString = String(data: lukeData, encoding: .utf8)
print(lukeString)

let plistEncoder = PropertyListEncoder()

//let plistData = try



