//
//  PokemonDetailViewModel.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import Foundation

@MainActor
@Observable
final class PokemonDetailViewModel {

    enum ViewState {
        case idle
        case loading
        case loaded(PokemonDetail)
        case failed(String)
    }

    private(set) var state: ViewState = .idle

    private let pokemonID: Int
    private let getPokemonDetail: GetPokemonDetailUseCase

    init(pokemonID: Int, getPokemonDetail: GetPokemonDetailUseCase) {
        self.pokemonID = pokemonID
        self.getPokemonDetail = getPokemonDetail
    }

    func load() async {
        guard case .idle = state else { return }
        await fetch()
    }

    func retry() async {
        await fetch()
    }

    private func fetch() async {
        state = .loading

        do {
            let detail = try await getPokemonDetail.execute(id: pokemonID)
            state = .loaded(detail)
        } catch {
            state = .failed(message(for: error))
        }
    }

    private func message(for error: Error) -> String {
        guard let networkError = error as? NetworkError else {
            return "Algo salió mal. Inténtalo de nuevo."
        }

        switch networkError {
        case .requestFailed:
            return "Sin conexión a internet."
        case .serverError:
            return "El servidor no responde. Inténtalo más tarde."
        case .invalidURL, .invalidResponse, .decodingFailed:
            return "No pudimos leer los datos de este pokémon."
        }
    }
}
