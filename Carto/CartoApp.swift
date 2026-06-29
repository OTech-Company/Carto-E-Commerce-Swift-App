//
//  CartoApp.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//

import SwiftUI
import Firebase

@main
struct CartoApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: AuthLoginViewModel(validator: AuthValidator()))
        }
    }
}
