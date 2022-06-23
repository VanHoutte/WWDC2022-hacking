//
//  ContentView.swift
//  wwdc2022
//
//  Created by Mathias Van Houtte on 23/06/2022.
//

import SwiftUI
import Combine

struct ContentView: View {
	@ObservedObject var viewModel: PokemonListViewModel
	@State var isList: Bool = true
	
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible()),
		]
	
	var body: some View {
		NavigationStack(path: $viewModel.path) {
			VStack {
				if isList {
					List(viewModel.pokemon, id: \.id) { pokemon in
						renderCell(pokemon: pokemon)
					}
				} else {
					ScrollView {
						LazyVGrid(columns: columns, spacing: 20) {
							ForEach(viewModel.pokemon, id: \.id) { pokemon in
								renderCell(pokemon: pokemon)
							}
						}
					}
				}
			}
			.navigationTitle("Pokemon")
			.navigationDestination(for: PokemonDetail.self, destination: { pokemon in
				PokemonDetailView(pokemon: pokemon, viewModel: viewModel)
			})
			.toolbar {
				Toggle("Show List", isOn: $isList)
				
				Button("Random") {
					setRandom()
				}
			}
		}
		.onAppear() {
			viewModel.fetchPokemon()
		}
	}
	
	func setRandom() {
		viewModel.setRandomPokemon()
	}
	
	func renderCell(pokemon: PokemonDetail) -> some View {
		NavigationLink(value: pokemon, label: {
			HStack {
				if let urlString = pokemon.sprites.other?.officialArtwork.frontDefault,
				   let url = URL(string: urlString) {
					AsyncImage(url: url,
							   content: { image in
						image.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 90, height:90)
					},
							   placeholder: {
						VStack {
							ProgressView()
						}
						.frame(width: 90, height:90)
					})
				}
				
				Text(pokemon.name.firstUppercased)
			}
			
		})
	}
}

struct PokemonDetailView: View {
	var pokemon: PokemonDetail
	var viewModel: PokemonListViewModel
	
	var body: some View {
		VStack {
			Rectangle()
				.fill(Color(uiColor: UIColor(hexaString: "#ee1515")))
				.ignoresSafeArea(edges: .top)
				.frame(height: 400)
			
			
			CircleImage(urlString: pokemon.sprites.other?.officialArtwork.frontDefault)
				.offset(y: -230)
				.padding(.bottom, -230)
			
			VStack(alignment: .leading) {
				Text(pokemon.name.firstUppercased)
					.font(.title)
			}
			.padding()
			
			Spacer()
		}
		.toolbar {
			Button("Random") {
				viewModel.setRandomPokemon()
			}
			
			Button("Replace current with random") {
				viewModel.replaceCurrentPokemon()
			}
			
			Button("Go back") {
				viewModel.goBack()
			}
		}
	}
}

struct CircleImage: View {
	var urlString: String?
	
	var body: some View {
		if let urlString = urlString,
		   let url = URL(string: urlString) {
			AsyncImage(url: url,
					   content: { image in
				image
					.background(Color.white)
					.clipShape(Circle())
					.overlay {
						Circle().stroke(.white, lineWidth: 4)
					}
					.shadow(radius: 7)
			},
					   placeholder: {
				VStack {
					ProgressView()
				}
				.clipShape(Circle())
				.overlay {
					Circle().stroke(.white, lineWidth: 4)
				}
				.shadow(radius: 7)
			})
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(viewModel: PokemonListViewModel())
	}
}

enum UIState {
	case loading
	case idle
}

class PokemonListViewModel: ObservableObject {
	private let api = PokeAPI()
	private var subscriptions = [AnyCancellable]()
	
	@Published var state: UIState = .idle
	@Published var pokemon: [PokemonDetail] = []
	
	@Published var path: [PokemonDetail] = []
	
	func fetchPokemon() {
		state = .loading
		api
			.fetchAllPokemon()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { error in
				print(error)
			}, receiveValue: { [weak self] pokemon in
				self?.pokemon = pokemon.sorted(by: { lhs, rhs in
					return lhs.id < rhs.id
				})
				self?.state = .idle
			})
			.store(in: &subscriptions)
	}
	
	func setRandomPokemon() {
		if let pokemon =  pokemon.randomElement() {
			path.append(pokemon)
		}
	}
	
	func replaceCurrentPokemon() {
		if let pokemon =  pokemon.randomElement() {
			path = [pokemon]
		}
	}
	
	func goBack() {
		path = []
	}
}

extension StringProtocol {
	var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
extension UIColor {
	convenience init(hexaString: String, alpha: CGFloat = 1) {
		let chars = Array(hexaString.dropFirst())
		self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
				  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
				  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
				  alpha: alpha)}
}
