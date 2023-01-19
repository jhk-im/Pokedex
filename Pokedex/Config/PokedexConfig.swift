//
//  Config.swift
//  Pokedex
//
//  Created by HUN on 2023/01/17.
//

import Foundation

struct PokedexConfig {
    
    enum Keys {
        static let appName = "APP_NAME"
        static let scheme = "SCHEME"
        static let host = "HOST"
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dictionary
    }()
    
    // MARK: - Plist Value
    static let appName: String = {
        let value = PokedexConfig.infoDictionary[Keys.appName]
        return value as? String ?? ""
    }()
    
    static let scheme: String = {
        let value = PokedexConfig.infoDictionary[Keys.scheme]
        return value as? String ?? ""
    }()
    
    static let host: String = {
        let value = PokedexConfig.infoDictionary[Keys.host]
        return value as? String ?? ""
    }()
    
    static let POKEMON_IMAGE_URL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
}
