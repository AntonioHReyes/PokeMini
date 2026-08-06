//
//  PokemonRepository.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 06/08/26.
//

protocol PokemonRepository {
    func getPokemonList(limit: Int, offset: Int) async throws -> [Pokemon]
    func getPokemon(id: Int) async throws -> PokemonDetail
}
