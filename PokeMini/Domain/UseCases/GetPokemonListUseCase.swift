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
    
    func execute(limit: Int, offset: Int) async throws -> [Pokemon] {
        try await repository.getPokemonList(limit: limit, offset: offset)
    }
}
