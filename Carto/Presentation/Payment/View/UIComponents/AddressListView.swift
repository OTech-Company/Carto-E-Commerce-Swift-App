//
//  AddressListView.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct AddressListView: View {
    @Environment(\.dismiss) private var dismiss
    
    let addresses: [CustomerAddress]
    let onSelect: (CustomerAddress) -> Void
    let onAddNew: () -> Void
    
    var body: some View {
        NavigationStack {
            List(addresses) { address in
                Button(action: {
                    onSelect(address)
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text("\(address.firstName) \(address.lastName)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                if address.isDefault {
                                    Text("Default")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.brandAccent)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.brandAccent.opacity(0.1))
                                        .cornerRadius(6)
                                }
                            }
                            
                            Text("\(address.address1), \(address.city)")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Select Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                        onAddNew()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.brandAccent)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
