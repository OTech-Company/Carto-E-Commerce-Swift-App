//
//  AddressListView.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct AddressListView: View {
    let addresses: [CustomerAddress]
    let onSelect: (CustomerAddress) -> Void
    
    var body: some View {
        NavigationStack {
            List(addresses) { address in
                Button(action: { onSelect(address) }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Customer Name").bold()
                        Text("\(address.address1), \(address.city)")
                    }
                }
            }
            .navigationTitle("Select Address")
        }
    }
}
