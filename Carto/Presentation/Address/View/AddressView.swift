//
//  AddressView.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

private struct AddressSheetItem: Identifiable {
    let id = UUID()
    let address: CustomerAddress?
}

struct AddressView: View {
    @StateObject var viewModel: AddressViewModel = DIContainer.shared
        .makeAddressViewModel()

    @State private var addressToDelete: CustomerAddress? = nil
    @State private var showAlert: Bool = false

    @State private var addressSheet: AddressSheetItem? = nil

    let customerId: String = "050024a0002062a460127a22eeb2fedf"

    var body: some View {
        content
            .navigationTitle("Addresses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addressSheet = AddressSheetItem(address: nil)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color("PrimaryColor"))
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadAllAdresses(for: customerId)
                }
            }
            .alert(
                "Delete Address",
                isPresented: $showAlert,
                presenting: addressToDelete
            ) { address in
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteAddress(
                            String(address.id),
                            for: customerId
                        )
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: { address in
                Text(
                    "Are you sure you want to delete this address? This action can't be undone."
                )
            }
            .sheet(item: $addressSheet) { sheet in
                AddressFormBottomSheet(
                    address: sheet.address,
                    onAdd: { newAddress in
                        Task {
                            await viewModel.addAddress(
                                newAddress,
                                for: customerId
                            )
                        }
                    },
                    onEdit: { updatedAddress in
                        Task {
                            await viewModel.editAddress(
                                for: customerId,
                                addressId: String(updatedAddress.id),
                                address: updatedAddress
                            )
                        }
                    }
                )
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
                                onEdit: {
                                    addressSheet = AddressSheetItem(
                                        address: address
                                    )
                                }
                            )
                        } else {
                            AddressCard(
                                address: address,
                                onEdit: {
                                    addressSheet = AddressSheetItem(
                                        address: address
                                    )
                                },
                                onDelete: {
                                    addressToDelete = address
                                    showAlert = true
                                },
                                onSetDefault: {
                                    Task {
                                        await viewModel.setDefaultAddress(
                                            String(address.id),
                                            for: customerId
                                        )
                                    }
                                }
                            )
                        }
                    }
                }
                .padding()
            }
            .background(Color("BackgroundColor"))
        }
    }
}

#Preview {
    AddressView()
}
