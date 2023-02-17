//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by HUN on 2023/02/16.
//

import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    private var pokemonNetwork = PokemonNetwork()
    private var cancellables = Set<AnyCancellable>()
    @Published var result: Pokemon? = nil
    @Published var isLoading = false
    
    func getPokemonDetail(id: Int) {
        isLoading = true
        pokemonNetwork.getPokemonDetail(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    guard case .failure(let error) = $0 else { return }
                    print("getPokemonDetail error -> \(error)")
                    self?.isLoading = false
                    self?.result = nil
                },
                receiveValue: { [weak self] pokemon in
                    print("getPokemonDetail success -> \(pokemon)")
                    self?.isLoading = false
                    self?.result = pokemon
                }
            )
            .store(in: &cancellables)
    }
}
