//
//  PokemonResponse.swift
//  Pokedex
//
//  Created by HUN on 2023/01/19.
//

import Foundation

struct PokemonResponse: Decodable {
    let data: Pokemon
}

struct Pokemon: Hashable, Decodable {
    let id : Int?
    let name : String?
    let height : Int?
    let weight : Int?
    let base_experience : Int?
    let types : [Types]?
    let stats : [Stats]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case height = "height"
        case weight = "weight"
        case base_experience = "base_experience"
        case types = "types"
        case stats = "stats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        weight = try values.decodeIfPresent(Int.self, forKey: .weight)
        base_experience = try values.decodeIfPresent(Int.self, forKey: .base_experience)
        types = try values.decodeIfPresent([Types].self, forKey: .types)
        stats = try values.decodeIfPresent([Stats].self, forKey: .stats)
    }
}

struct Types : Hashable, Decodable {
    let slot : Int?
    let type : Type?

    enum CodingKeys: String, CodingKey {
        case slot = "slot"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slot = try values.decodeIfPresent(Int.self, forKey: .slot)
        type = try values.decodeIfPresent(Type.self, forKey: .type)
    }
}

struct Type : Hashable, Decodable {
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
}

struct Stats : Hashable, Decodable {
    let base_stat : Int?
    let effort : Int?
    let stat : Stat?

    enum CodingKeys: String, CodingKey {
        case base_stat = "base_stat"
        case effort = "effort"
        case stat = "stat"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base_stat = try values.decodeIfPresent(Int.self, forKey: .base_stat)
        effort = try values.decodeIfPresent(Int.self, forKey: .effort)
        stat = try values.decodeIfPresent(Stat.self, forKey: .stat)
    }
}

struct Stat : Hashable, Decodable {
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
}
