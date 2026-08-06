//
//  GetPokemonDetail.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 06/08/26.
//

struct GetPokemonDetailUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> PokemonDetail {
        try await repository.getPokemon(id: id)
    }
}
