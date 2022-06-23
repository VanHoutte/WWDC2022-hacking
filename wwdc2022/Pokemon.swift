//
//  Pokemon.swift
//  wwdc2022
//
//  Created by Mathias Van Houtte on 23/06/2022.
//

import Foundation

struct PokemonList: Codable {
	let results: [Pokemon]
}

struct Pokemon: Codable, Hashable {
	let url: String
	let name: String
}

// MARK: - Welcome
struct PokemonDetail: Identifiable, Codable, Hashable {
	static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
		return lhs.id == rhs.id
	}
	
	let abilities: [Ability]
	let baseExperience: Int
	let forms: [Species]
	let gameIndices: [GameIndex]
	let height: Int
	let id: Int
	let isDefault: Bool
	let locationAreaEncounters: String
	let moves: [Move]
	let name: String
	let order: Int
	let species: Species
	let sprites: Sprites
	let stats: [Stat]
	let types: [TypeElement]
	let weight: Int

	enum CodingKeys: String, CodingKey {
		case abilities
		case baseExperience = "base_experience"
		case forms
		case gameIndices = "game_indices"
		case height
		case id
		case isDefault = "is_default"
		case locationAreaEncounters = "location_area_encounters"
		case moves, name, order
		case species, sprites, stats, types, weight
	}
}

// MARK: - Ability
struct Ability: Codable, Hashable {
	let ability: Species
	let isHidden: Bool
	let slot: Int

	enum CodingKeys: String, CodingKey {
		case ability
		case isHidden = "is_hidden"
		case slot
	}
}

// MARK: - Species
struct Species: Codable, Hashable {
	let name: String
	let url: String
}

// MARK: - GameIndex
struct GameIndex: Codable, Hashable {
	let gameIndex: Int
	let version: Species

	enum CodingKeys: String, CodingKey {
		case gameIndex = "game_index"
		case version
	}
}

// MARK: - Move
struct Move: Codable, Hashable {
	let move: Species
	let versionGroupDetails: [VersionGroupDetail]

	enum CodingKeys: String, CodingKey {
		case move
		case versionGroupDetails = "version_group_details"
	}
}

// MARK: - VersionGroupDetail
struct VersionGroupDetail: Codable, Hashable {
	let levelLearnedAt: Int
	let moveLearnMethod, versionGroup: Species

	enum CodingKeys: String, CodingKey {
		case levelLearnedAt = "level_learned_at"
		case moveLearnMethod = "move_learn_method"
		case versionGroup = "version_group"
	}
}

// MARK: - GenerationV
struct GenerationV: Codable, Hashable {
	let blackWhite: Sprites

	enum CodingKeys: String, CodingKey {
		case blackWhite = "black-white"
	}
}

// MARK: - GenerationIv
struct GenerationIv: Codable, Hashable {
	let diamondPearl, heartgoldSoulsilver, platinum: Sprites

	enum CodingKeys: String, CodingKey {
		case diamondPearl = "diamond-pearl"
		case heartgoldSoulsilver = "heartgold-soulsilver"
		case platinum
	}
}

// MARK: - Versions
struct Versions: Codable, Hashable {
	let generationI: GenerationI
	let generationIi: GenerationIi
	let generationIii: GenerationIii
	let generationIv: GenerationIv
	let generationV: GenerationV
	let generationVi: [String: Home]
	let generationVii: GenerationVii
	let generationViii: GenerationViii

	enum CodingKeys: String, CodingKey {
		case generationI = "generation-i"
		case generationIi = "generation-ii"
		case generationIii = "generation-iii"
		case generationIv = "generation-iv"
		case generationV = "generation-v"
		case generationVi = "generation-vi"
		case generationVii = "generation-vii"
		case generationViii = "generation-viii"
	}
}

// MARK: - Sprites
struct Sprites: Codable, Hashable {
	let other: Other?

	enum CodingKeys: String, CodingKey {
		case other
	}

	init(other: Other?) {
		self.other = other
	}
}

// MARK: - GenerationI
struct GenerationI: Codable, Hashable {
	let redBlue, yellow: RedBlue

	enum CodingKeys: String, CodingKey {
		case redBlue = "red-blue"
		case yellow
	}
}

// MARK: - RedBlue
struct RedBlue: Codable, Hashable {
	let backDefault, backGray, backTransparent, frontDefault: String
	let frontGray, frontTransparent: String

	enum CodingKeys: String, CodingKey {
		case backDefault = "back_default"
		case backGray = "back_gray"
		case backTransparent = "back_transparent"
		case frontDefault = "front_default"
		case frontGray = "front_gray"
		case frontTransparent = "front_transparent"
	}
}

// MARK: - GenerationIi
struct GenerationIi: Codable, Hashable {
	let crystal: Crystal
	let gold, silver: Gold
}

// MARK: - Crystal
struct Crystal: Codable, Hashable {
	let backDefault, backShiny, backShinyTransparent, backTransparent: String
	let frontDefault, frontShiny, frontShinyTransparent, frontTransparent: String

	enum CodingKeys: String, CodingKey {
		case backDefault = "back_default"
		case backShiny = "back_shiny"
		case backShinyTransparent = "back_shiny_transparent"
		case backTransparent = "back_transparent"
		case frontDefault = "front_default"
		case frontShiny = "front_shiny"
		case frontShinyTransparent = "front_shiny_transparent"
		case frontTransparent = "front_transparent"
	}
}

// MARK: - Gold
struct Gold: Codable, Hashable {
	let backDefault, backShiny, frontDefault, frontShiny: String
	let frontTransparent: String?

	enum CodingKeys: String, CodingKey {
		case backDefault = "back_default"
		case backShiny = "back_shiny"
		case frontDefault = "front_default"
		case frontShiny = "front_shiny"
		case frontTransparent = "front_transparent"
	}
}

// MARK: - GenerationIii
struct GenerationIii: Codable, Hashable {
	let emerald: Emerald
	let fireredLeafgreen, rubySapphire: Gold

	enum CodingKeys: String, CodingKey {
		case emerald
		case fireredLeafgreen = "firered-leafgreen"
		case rubySapphire = "ruby-sapphire"
	}
}

// MARK: - Emerald
struct Emerald: Codable, Hashable {
	let frontDefault, frontShiny: String

	enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
		case frontShiny = "front_shiny"
	}
}

// MARK: - Home
struct Home: Codable, Hashable {
	let frontDefault: String
	let frontShiny: String

	enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
		case frontShiny = "front_shiny"
	}
}

// MARK: - GenerationVii
struct GenerationVii: Codable, Hashable {
	let icons: DreamWorld
	let ultraSunUltraMoon: Home

	enum CodingKeys: String, CodingKey {
		case icons
		case ultraSunUltraMoon = "ultra-sun-ultra-moon"
	}
}

// MARK: - DreamWorld
struct DreamWorld: Codable, Hashable {
	let frontDefault: String

	enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
	}
}

// MARK: - GenerationViii
struct GenerationViii: Codable, Hashable {
	let icons: DreamWorld
}

// MARK: - Other
struct Other: Codable, Hashable {
	let dreamWorld: DreamWorld
	let home: Home
	let officialArtwork: OfficialArtwork

	enum CodingKeys: String, CodingKey {
		case dreamWorld = "dream_world"
		case home
		case officialArtwork = "official-artwork"
	}
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable, Hashable {
	let frontDefault: String

	enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
	}
}

// MARK: - Stat
struct Stat: Codable, Hashable {
	let baseStat, effort: Int
	let stat: Species

	enum CodingKeys: String, CodingKey {
		case baseStat = "base_stat"
		case effort, stat
	}
}

// MARK: - TypeElement
struct TypeElement: Codable, Hashable {
	let slot: Int
	let type: Species
}
