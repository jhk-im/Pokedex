//
//  PokemonAPI.swift
//  Pokedex
//
//  Created by HUN on 2023/01/19.
//

import Foundation

struct PokemonAPI {
    
    func getPokemonList(offset: Int, limit: Int) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = PokedexConfig.scheme
        components.host = PokedexConfig.host
        components.path = "/api/v2/pokemon"
        
        components.queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        return components
    }
    
    func getPokemonDetail(id: Int) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = PokedexConfig.scheme
        components.host = PokedexConfig.host
        components.path = "/api/v2/pokemon/\(id)/"
        
        return components
    }
}
