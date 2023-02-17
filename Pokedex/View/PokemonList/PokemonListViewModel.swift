//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by HUN on 2023/02/07.
//

import Foundation
import Combine

class PokemonListViewModel: ObservableObject {
    private var pokemonNetwork = PokemonNetwork()
    private var cancellables = Set<AnyCancellable>()
    private var mOffset = 0
    private let mLimit = 20
    @Published var results = [Results]()
    @Published var isLoading = false
    
    init() {
        getPokemonList(isFirst: true)
    }
    
    // MARK: - pokemonList
    func getPokemonList(isFirst: Bool) {
        isLoading = true
        if !isFirst {
            mOffset += mLimit
        }
        pokemonNetwork.getPokemonList(offset: mOffset, limit: mLimit)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    guard case .failure(let error) = $0 else { return }
                    print("getPokemonList error -> \(error)")
                    self?.results = [Results]()
                    self?.isLoading = false
                },
                receiveValue: { [weak self] pokemonList in
                    print("getPokemonList success -> \(pokemonList)")
                    if let res = pokemonList.results {
                        self?.results += res
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self?.isLoading = false
                        }
                    }
                }
            )
            .store(in: &cancellables)
    }
}
