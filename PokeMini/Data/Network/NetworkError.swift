//
//  NetworkError.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 07/08/26.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int)
}
