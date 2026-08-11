//
//  PokemonListViewModel.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import Foundation

@MainActor
@Observable
final class PokemonListViewModel {

    enum ViewState {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private(set) var pokemons: [Pokemon] = []
    private(set) var state: ViewState = .idle
    private(set) var paginationError: String?

    private let getPokemonList: GetPokemonListUseCase
    private let pageSize = 20
    private var offset = 0
    private var hasMorePages = true
    private var isLoadingPage = false

    init(getPokemonList: GetPokemonListUseCase) {
        self.getPokemonList = getPokemonList
    }

    var canLoadMore: Bool {
        hasMorePages && paginationError == nil
    }

    func loadFirstPage() async {
        guard case .idle = state else {
            return
        }
        await loadPage(reset: true)
    }

    func loadNextPage() async {
        guard case .loaded = state, canLoadMore else {
            return
        }
        await loadPage(reset: false)
    }

    func retry() async {
        await loadPage(reset: pokemons.isEmpty)
    }

    private func loadPage(reset: Bool) async {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        defer { isLoadingPage = false }

        if reset {
            offset = 0
            pokemons = []
            hasMorePages = true
            state = .loading
        }
        paginationError = nil

        do {
            let page = try await getPokemonList.execute(
                limit: pageSize,
                offset: offset
            )
            pokemons.append(contentsOf: page)
            offset += page.count
            hasMorePages = page.count == pageSize
            state = .loaded
        } catch {
            if pokemons.isEmpty {
                state = .failed(message(for: error))
            } else {
                paginationError = message(for: error)
            }
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
            return "Algo salió mal. Inténtalo de nuevo."
        }
    }
}
