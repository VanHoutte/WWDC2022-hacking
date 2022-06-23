//
//  PokeAPI.swift
//  wwdc2022
//
//  Created by Mathias Van Houtte on 23/06/2022.
//

import Foundation
import Combine

enum EndPoint {
	static let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
	
	case list
	
	var url: URL {
		switch self {
		case .list:
			return EndPoint.baseURL.appending(queryItems: [.init(name: "limit", value: "151")])
		}
	}
}
enum Error: LocalizedError {
	case addressUnreachable(URL)
	case invalidResponse
	
	var errorDescription: String? {
		switch self {
		case .invalidResponse:
			return "Invalid response from the server"
		case .addressUnreachable(let url):
			return "Unreachable URL: \(url.absoluteString)"
		}
	}
}

struct PokeAPI {
	
	/// Private decoder for JSON decoding
	private let decoder = JSONDecoder()
	
	/// Specify the scheduler that manages the responses
	private let apiQueue = DispatchQueue(label: "Pokemon",
										 qos: .default,
										 attributes: .concurrent)
	
	func fetchAllPokemon() -> AnyPublisher<[PokemonDetail], Error> {
		fetchPokemon().flatMap { pokemon in
			Publishers.Sequence(sequence: pokemon.map { self.fetchPokemonByUrl(url: URL(string: $0.url)!)})
				.flatMap { $0 }
				.collect()
		}
		.eraseToAnyPublisher()
	}
	
	private func fetchPokemon() -> AnyPublisher<[Pokemon], Error> {
		URLSession.shared
			.dataTaskPublisher(for: EndPoint.list.url)
			.receive(on: apiQueue)
			.map(\.data)
			.decode(type: PokemonList.self, decoder: decoder)
			.map { $0.results }
			.catch { _ in Empty<[Pokemon], Error>() }
			.eraseToAnyPublisher()
	}
	
	private func fetchPokemonByUrl(url: URL) -> AnyPublisher<PokemonDetail, Error> {
			URLSession.shared
				.dataTaskPublisher(for: url)
				.receive(on: apiQueue)
				.map(\.data)
				.decode(type: PokemonDetail.self, decoder: decoder)
				.catch { error in
					print(error)
					return Empty<PokemonDetail, Error>() }
				.eraseToAnyPublisher()
	}
}
