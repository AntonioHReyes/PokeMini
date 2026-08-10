//
//  PokemonArtwork.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import Foundation

enum PokemonArtwork {
    private static let baseURL =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"

    static func url(for id: Int) -> URL? {
        URL(string: "\(baseURL)\(id).png")
    }
}
