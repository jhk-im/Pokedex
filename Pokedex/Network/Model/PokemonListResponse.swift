//
//  PokemonListResponse.swift
//  Pokedex
//
//  Created by HUN on 2023/01/19.
//

import Foundation

struct PokemonList: Codable {
    let count : Int?
    let next : String?
    let previous : String?
    let results : [Results]?

    enum CodingKeys: String, CodingKey {

        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        next = try values.decodeIfPresent(String.self, forKey: .next)
        previous = try values.decodeIfPresent(String.self, forKey: .previous)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
}

struct Results : Codable {
    let name : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
    func getImageUrl() -> String {
        let indexString = url?.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon/", with: "")
        let idx = indexString?.replacingOccurrences(of: "/", with: "") ?? ""
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(idx).png"
    }
}
