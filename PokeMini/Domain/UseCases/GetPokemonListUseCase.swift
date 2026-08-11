//
//  GetPokemonListUseCase.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 06/08/26.
//

struct GetPokemonListUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(limit: Int = 20, offset: Int = 0) async throws -> [Pokemon] {
        try await repository.getPokemonList(limit: limit, offset: offset)
    }
}
