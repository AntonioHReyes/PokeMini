//
//  ErrorView.swift
//  PokeMini
//
//  Created by Antonio Huerta Reyes on 10/08/26.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Algo salió mal", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Reintentar", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
    }
}
