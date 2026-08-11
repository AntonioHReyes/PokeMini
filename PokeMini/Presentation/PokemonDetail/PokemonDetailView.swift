//
//  PokemonDetailView.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import SwiftUI

struct PokemonDetailView: View {
    private let pokemonName: String
    @State private var viewModel: PokemonDetailViewModel

    init(pokemon: Pokemon, getPokemonDetail: GetPokemonDetailUseCase) {
        self.pokemonName = pokemon.name
        _viewModel = State(
            initialValue: PokemonDetailViewModel(
                pokemonID: pokemon.id,
                getPokemonDetail: getPokemonDetail
            )
        )
    }

    var body: some View {
        content
            .navigationTitle(pokemonName.capitalized)
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ErrorView(message: message) {
                Task { await viewModel.retry() }
            }

        case .loaded(let detail):
            loadedContent(detail)
        }
    }

    private func loadedContent(_ detail: PokemonDetail) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                artwork(detail)
                typeChips(detail.types)
                measurements(detail)
                statsSection(detail.stats)
            }
            .padding()
        }
    }

    private func artwork(_ detail: PokemonDetail) -> some View {
        AsyncImage(url: detail.imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            default:
                ProgressView()
            }
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func typeChips(_ types: [String]) -> some View {
        HStack(spacing: 8) {
            ForEach(types, id: \.self) { type in
                Text(type.capitalized)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(PokemonTypeStyle.color(for: type), in: Capsule())
            }
        }
    }

    private func measurements(_ detail: PokemonDetail) -> some View {
        HStack(spacing: 16) {
            measurementCard(
                title: "Peso",
                value: String(format: "%.1f kg", Double(detail.weight) / 10)
            )
            measurementCard(
                title: "Altura",
                value: String(format: "%.1f m", Double(detail.height) / 10)
            )
        }
    }

    private func measurementCard(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func statsSection(_ stats: [PokemonStat]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estadísticas base")
                .font(.headline)

            ForEach(stats) { stat in
                StatRow(stat: stat)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct StatRow: View {
    let stat: PokemonStat

    /// 255 es el valor máximo teórico de una stat base en la PokéAPI.
    private static let maxStatValue = 255.0

    var body: some View {
        HStack(spacing: 12) {
            Text(displayName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 110, alignment: .leading)

            ProgressView(value: Double(stat.value), total: Self.maxStatValue)
                .tint(barColor)

            Text("\(stat.value)")
                .font(.subheadline.monospacedDigit())
                .frame(width: 36, alignment: .trailing)
        }
    }

    private var displayName: String {
        stat.name
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
    }

    private var barColor: Color {
        switch stat.value {
        case ..<60: .red
        case 60..<100: .orange
        default: .green
        }
    }
}
