import UIKit

struct Pokemon: Decodable {
    
    let name: String
    let species: String
    let abilities: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case species
        case abilities
        
        enum SpeciesKeys: String, CodingKey {
            case name
        }
        
        enum AbilityDescriptionKeys: String, CodingKey {
            case ability
            
            enum AbilityKeys: String, CodingKey {
                case name
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        let speciesContainer = try container.nestedContainer(keyedBy: CodingKeys.SpeciesKeys.self, forKey: .species)
        species = try speciesContainer.decode(String.self, forKey: .name)
        
        var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        var abilityNames: [String] = []
        while abilitiesContainer.isAtEnd == false {
            let abilityDescriptionContainer = try abilitiesContainer.nestedContainer(keyedBy: CodingKeys.AbilityDescriptionKeys.self)
            
            let abilityContainer = try abilityDescriptionContainer.nestedContainer(keyedBy: CodingKeys.AbilityDescriptionKeys.AbilityKeys.self, forKey: .ability)
            
            let abilityName = try abilityContainer.decode(String.self, forKey: .name)
            abilityNames.append(abilityName)
        }
        abilities = abilityNames
    }
}

let url = URL(string: "https://pokeapi.co/api/v2/pokemon/4")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let charmander = try decoder.decode(Pokemon.self, from: data)


