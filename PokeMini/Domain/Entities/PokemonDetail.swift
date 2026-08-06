//
//  PokemonDetail.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 06/08/26.
//

import Foundation

struct PokemonDetail: Identifiable {
    let id: Int
    let name: String
    let imageURL: URL
    let types: [String]
    let weight: Int
    let height: Int
    let stats: [PokemonStat]
}
