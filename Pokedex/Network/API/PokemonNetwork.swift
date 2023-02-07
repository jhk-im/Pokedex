//
//  PokemonNetwork.swift
//  Pokedex
//
//  Created by HUN on 2023/01/19.
//

import Foundation
import Combine

class PokemonNetwork {
    private let session: URLSession
    let api = PokemonAPI()
    
    init (session: URLSession = .shared) {
        self.session = session
    }
    
    func getPokemonList(offset: Int, limit: Int) -> AnyPublisher<PokemonList, URLError> {
        guard let url = api.getPokemonList(offset: offset, limit: limit).url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    print("getPokemonList() -> success")
                    return data
                case 400..<500:
                    print("getNaverLogin() -> \(String(describing: NetworkManager.statusDesc[httpResponse.statusCode]))")
                    throw URLError(.clientCertificateRejected)
                case 500..<599:
                    print("getNaverLogin() -> \(String(describing: NetworkManager.statusDesc[httpResponse.statusCode]))")
                    throw URLError(.badServerResponse)
                default:
                    throw URLError(.unknown)
                }
            }
            .decode(type: PokemonList.self, decoder: JSONDecoder())
            .map { $0 }
            .mapError { $0 as? URLError ?? URLError(.unknown) }
            .eraseToAnyPublisher()
    }
    
    func getPokemonDetail(id: Int) -> AnyPublisher<Pokemon, URLError> {
        guard let url = api.getPokemonDetail(id: id).url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    print("getPokemonList() -> success")
                    return data
                case 400..<500:
                    print("getNaverLogin() -> \(String(describing: NetworkManager.statusDesc[httpResponse.statusCode]))")
                    throw URLError(.clientCertificateRejected)
                case 500..<599:
                    print("getNaverLogin() -> \(String(describing: NetworkManager.statusDesc[httpResponse.statusCode]))")
                    throw URLError(.badServerResponse)
                default:
                    throw URLError(.unknown)
                }
            }
            .decode(type: Pokemon.self, decoder: JSONDecoder())
            .map { $0 }
            .mapError { $0 as? URLError ?? URLError(.unknown) }
            .eraseToAnyPublisher()
    }
}
