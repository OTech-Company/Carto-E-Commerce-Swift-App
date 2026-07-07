//
//  AddEditAddressView.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct AddEditAddressView: View {
    let onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Simulate Save Operations", action: onSave)
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add New Address")
        }
    }
}
