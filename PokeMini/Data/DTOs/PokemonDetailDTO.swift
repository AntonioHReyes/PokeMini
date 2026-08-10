//
//  PokemonDetailDTO.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import Foundation

struct PokemonDetailDTO: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeSlotDTO]
    let stats: [PokemonStatDTO]
}

struct PokemonTypeSlotDTO: Decodable {
    let slot: Int
    let type: NamedAPIResourceDTO
}

struct PokemonStatDTO: Decodable {
    let baseStat: Int
    let stat: NamedAPIResourceDTO

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

extension PokemonStatDTO {
    func toDomain() -> PokemonStat {
        PokemonStat(name: stat.name, value: baseStat)
    }
}

extension PokemonDetailDTO {
    func toDomain() -> PokemonDetail? {
        guard let imageURL = PokemonArtwork.url(for: id) else {
            return nil
        }

        return PokemonDetail(
            id: id,
            name: name,
            imageURL: imageURL,
            types: types.sorted { $0.slot < $1.slot }.map { $0.type.name },
            weight: weight,
            height: height,
            stats: stats.map { $0.toDomain() }
        )
    }
}
