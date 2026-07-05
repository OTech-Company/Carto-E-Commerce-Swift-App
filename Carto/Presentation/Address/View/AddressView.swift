//
//  AddressView.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

struct AddressView: View {
    @StateObject var viewModel: AddressViewModel = DIContainer.shared
        .makeAddressViewModel()
    let customerId: String = "10440744534060"

    var body: some View {
        content
            .navigationTitle("Addresses")
            .task {
                await viewModel.loadAllAdresses(for: customerId)
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            LoadingView(width: .infinity, height: .infinity)
                .padding()
        } else if let error = viewModel.errorMessage {
            ErrorView(width: .infinity, height: .infinity, message: error)
                .padding()
        } else if viewModel.addresses.isEmpty {
            EmptyStateView(
                image: "mappin.slash",
                title: "No avilable addresses found",
            )
        } else {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(viewModel.addresses) { address in
                        if address.isDefault {
                            AddressCard(
                                address: address,
                                onEdit: {}
                            )
                        } else {
                            AddressCard(
                                address: address,
                                onEdit: {},
                                onDelete: {},
                                onSetDefault: {}
                            )
                        }
                    }
                }
                .padding()
            }
            .background(Color("BackgroundColor"))
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: "Add New Address") {

                }
                .padding()
            }
        }
    }
}

#Preview {
    AddressView()
}
