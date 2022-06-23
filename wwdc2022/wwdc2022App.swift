//
//  wwdc2022App.swift
//  wwdc2022
//
//  Created by Mathias Van Houtte on 23/06/2022.
//

import SwiftUI

@main
struct wwdc2022App: App {
    var body: some Scene {
        WindowGroup {
			ContentView(viewModel: PokemonListViewModel())
        }
    }
}
