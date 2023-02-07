//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by HUN on 2023/02/07.
//

import SwiftUI

struct PokemonListItem: View {
    var name: String
    var imageUrl: String
    
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl), scale: 50) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Color.gray // Indicates an error.
                }
            }
            .frame(width: 100, height: 100)
            
                    
            Text(name)
            Spacer()
        }
    }
}

struct PokemonListItem_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListItem(name: "bulbasaur", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
    }
}
