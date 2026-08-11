//
//  AppDependencies.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

/// Composition root: el único lugar donde se arma el grafo de dependencias.
/// Es también el único punto de la app que conoce la capa Data.
struct AppDependencies {
    let getPokemonList: GetPokemonListUseCase
    let getPokemonDetail: GetPokemonDetailUseCase

    init(repository: PokemonRepository = PokemonRepositoryImpl()) {
        self.getPokemonList = GetPokemonListUseCase(repository: repository)
        self.getPokemonDetail = GetPokemonDetailUseCase(repository: repository)
    }
}
