//
//  PokemonListView.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import SwiftUI

struct PokemonListView: View {
    @State private var viewModel: PokemonListViewModel

    init(getPokemonList: GetPokemonListUseCase) {
        _viewModel = State(
            initialValue: PokemonListViewModel(getPokemonList: getPokemonList)
        )
    }

    var body: some View {
        content
            .navigationTitle("Pokédex")
            .task {
                await viewModel.loadFirstPage()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Cargando…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ErrorView(message: message) {
                Task { await viewModel.retry() }
            }

        case .loaded:
            pokemonList
        }
    }

    private var pokemonList: some View {
        List {
            ForEach(viewModel.pokemons) { pokemon in
                NavigationLink(value: pokemon) {
                    PokemonRow(pokemon: pokemon)
                }
                .onAppear {
                    guard pokemon.id == viewModel.pokemons.last?.id else { return }
                    Task { await viewModel.loadNextPage() }
                }
            }

            if let paginationError = viewModel.paginationError {
                paginationFooter(message: paginationError)
            } else if viewModel.canLoadMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }

    private func paginationFooter(message: String) -> some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button("Reintentar") {
                Task { await viewModel.retry() }
            }
        }
        .frame(maxWidth: .infinity)
        .listRowSeparator(.hidden)
    }
}
