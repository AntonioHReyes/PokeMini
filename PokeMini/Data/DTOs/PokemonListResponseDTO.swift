//
//  PokemonListResponseDTO.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

struct NamedAPIResourceDTO: Decodable {
    let name: String
    let url: String
}

struct PokemonListResponseDTO: Decodable {
    let count: Int
    let results: [NamedAPIResourceDTO]
}

extension NamedAPIResourceDTO {
    func toDomain() -> Pokemon? {
        guard let idString = url.split(separator: "/").last,
              let id = Int(idString),
              let imageURL = PokemonArtwork.url(for: id)
        else {
            return nil
        }

        return Pokemon(id: id, name: name, imageURL: imageURL)
    }
}
