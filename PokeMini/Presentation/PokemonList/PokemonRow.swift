//
//  PokemonRow.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import SwiftUI

struct PokemonRow: View {
    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: pokemon.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                default:
                    ProgressView()
                }
            }
            .frame(width: 64, height: 64)

            Text(pokemon.name.capitalized)
                .font(.headline)

            Spacer()

            Text("#\(pokemon.id)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .padding(.trailing, 8)
    }
}
