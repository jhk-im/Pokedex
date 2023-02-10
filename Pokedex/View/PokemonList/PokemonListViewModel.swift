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
    private var mOffset = 0
    private let mLimit = 10
    @Published var results = [Results]()
    
//    @Published var mId = 1
//    @Published var mPokemon: Pokemon? = nil
    
    init() {
        getPokemonList(isFirst: true)
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
    
    // MARK: - pokemonList
    func getPokemonList(isFirst: Bool) {
        
        if !isFirst {
            mOffset += mLimit
        }
        PokemonNetwork().getPokemonList(offset: mOffset, limit: mLimit)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    guard case .failure(let error) = $0 else { return }
                    print("getPokemonList error -> \(error)")
                    self?.results = [Results]()
                },
                receiveValue: { [weak self] pokemonList in
                    print("getPokemonList success -> \(pokemonList)")
                    if let res = pokemonList.results {
                        self?.results += res
                    }
                }
            )
            .store(in: &cancellables)
    }
}
