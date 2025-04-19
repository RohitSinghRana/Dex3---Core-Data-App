//
//  FetchController.swift
//  Dex3
//
//  Created by Rohit Singh Rana on 09/02/25.
//

import Foundation

struct FetchController {
    enum NetwordError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchAllPokemons() async throws -> [TempPokemon] {
        var allPokemon: [TempPokemon] = []
        var fetchComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponent?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        guard let fetchURL = fetchComponent?.url else {
            throw NetwordError.badURL
        }
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetwordError.badResponse
        }
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
            throw NetwordError.badData
        }
        
        for pokemon in pokedex {
            if let url = URL(string: pokemon["url"]!) {
                allPokemon.append(try await fetchPokemon(url: url))
            }
        }
        return allPokemon
    }
    
    private func fetchPokemon(url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetwordError.badResponse
        }
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        print("Fetched: \(tempPokemon.id): \(tempPokemon.name)")
        return tempPokemon
    }
}
