//
//  PokemonStat.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 06/08/26.
//

import Foundation

struct PokemonStat: Identifiable {
    let name: String
    let value: Int
    
    var id: String { name }
}
