//
//  PokeMiniApp.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 06/08/26.
//

import SwiftUI

@main
struct PokeMiniApp: App {
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}
