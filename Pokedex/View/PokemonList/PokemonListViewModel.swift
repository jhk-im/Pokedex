//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by HUN on 2023/02/07.
//

import Foundation
import Combine

class PokemonListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var mOffset = 0
    @Published var mLimit = 10
    @Published var mPokemonList: PokemonList? = nil
    
//    @Published var mId = 1
//    @Published var mPokemon: Pokemon? = nil
    
    init(pokemonNetwork : PokemonNetwork = PokemonNetwork()) {
        
        // MARK: - pokemonList
        pokemonNetwork.getPokemonList(offset: mOffset, limit: mLimit)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    guard case .failure(let error) = $0 else { return }
                    print("getPokemonList error -> \(error)")
                    self?.mPokemonList = nil
                },
                receiveValue: { [weak self] pokemonList in
                    print("getPokemonList success -> \(pokemonList)")
                    self?.mPokemonList = pokemonList
                }
            )
            .store(in: &cancellables)
            
        // MARK: - pokemonDetail
//        pokemonNetwork.getPokemonDetail(id: 1)
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: { [weak self] in
//                    guard case .failure(let error) = $0 else { return }
//                    print("getPokemonDetail error -> \(error)")
//                    self?.mPokemonList = nil
//                },
//                receiveValue: { [weak self] pokemon in
//                    print("getPokemonDetail success -> \(pokemon)")
//                    self?.mPokemon = pokemon
//
//                }
//            )
//            .store(in: &cancellables)
    }
}
