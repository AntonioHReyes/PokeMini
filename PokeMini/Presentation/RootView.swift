//
//  RootView.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import SwiftUI

/// Dueña de la navegación de la app: mantiene el stack y declara a qué
/// pantalla corresponde cada valor empujado. Las pantallas solo emiten
/// la intención (`NavigationLink(value:)`), no conocen el destino.
struct RootView: View {
    let dependencies: AppDependencies

    var body: some View {
        NavigationStack {
            PokemonListView(getPokemonList: dependencies.getPokemonList)
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailView(
                        pokemon: pokemon,
                        getPokemonDetail: dependencies.getPokemonDetail
                    )
                }
        }
    }
}
