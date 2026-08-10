//
//  PokemonRepositoryImpl.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import Foundation

struct PokemonRepositoryImpl: PokemonRepository {
    private static let baseURL = "https://pokeapi.co/api/v2/pokemon"
    private let networkService: NetworkService
    
    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }
    
    func getPokemonList(limit: Int, offset: Int) async throws -> [Pokemon] {
        var components = URLComponents(string: Self.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let response: PokemonListResponseDTO = try await networkService.fetch(from: url)
        
        return response.results.compactMap{ $0.toDomain() }
    }
    
    func getPokemon(id: Int) async throws -> PokemonDetail {
        guard let url = URL(string: "\(Self.baseURL)/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        let response: PokemonDetailDTO = try await networkService.fetch(from: url)
        guard let detail = response.toDomain() else {
            throw NetworkError.invalidResponse
        }
        
        return detail
    }
}
