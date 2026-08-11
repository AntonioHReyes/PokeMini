//
//  PokemonTypeStyle.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import SwiftUI

/// Colores de marca por tipo de pokémon. Vive en Presentation porque
/// es una decisión puramente visual: el dominio solo conoce el nombre.
enum PokemonTypeStyle {

    static func color(for type: String) -> Color {
        switch type {
        case "fire": .orange
        case "water": .blue
        case "grass": .green
        case "electric": .yellow
        case "ice": .cyan
        case "fighting": .red
        case "poison": .purple
        case "ground": .brown
        case "flying": .indigo
        case "psychic": .pink
        case "bug": .mint
        case "rock": .brown
        case "ghost": .indigo
        case "dragon": .indigo
        case "dark": .black
        case "steel": .gray
        case "fairy": .pink
        default: .gray
        }
    }
}
