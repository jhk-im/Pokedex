//
//  PokemonList.swift
//  Pokedex
//
//  Created by HUN on 2023/02/07.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel = PokemonListViewModel()
    
    var body: some View {
        List(viewModel.mPokemonList?.results ?? [], id: \.name) { result in
            PokemonListItem(name: result.name ?? "", imageUrl: result.getImageUrl())
        }
    }
    
    func test() {
        
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PokemonListViewModel()
        PokemonListView(viewModel: viewModel)
    }
}
