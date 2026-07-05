//
//  AddressFormBottomSheet.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

struct AddressFormBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var formData: NewAddress

    private let isEditing: Bool
    private let onAdd: (NewAddress) -> Void
    private let onEdit: (NewAddress) -> Void

    init(
        address: NewAddress? = nil,
        onAdd: @escaping (NewAddress) -> Void,
        onEdit: @escaping (NewAddress) -> Void
    ) {
        _formData = State(
            initialValue: address
                ?? NewAddress(
                    address1: "",
                    city: "",
                    province: "",
                    country: "",
                    zip: "",
                    phone: "",
                    firstName: "",
                    lastName: "",
                    company: ""
                )
        )
        self.isEditing = address != nil
        self.onAdd = onAdd
        self.onEdit = onEdit
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    HStack(spacing: 12) {
                        AddressField(
                            title: "First name",
                            isRequired: true,
                            text: $formData.firstName,
                            textContentType: .givenName
                        )
                        AddressField(
                            title: "Last name",
                            isRequired: true,
                            text: $formData.lastName,
                            textContentType: .familyName
                        )
                    }

                    Divider().overlay(Color("TintColor"))

                    Group {
                        AddressField(
                            title: "Address",
                            isRequired: true,
                            text: $formData.address1,
                            textContentType: .streetAddressLine1
                        )

                        HStack(spacing: 12) {
                            AddressField(
                                title: "City",
                                isRequired: true,
                                text: $formData.city,
                                textContentType: .addressCity
                            )
                            AddressField(
                                title: "Zip",
                                isRequired: true,
                                text: $formData.zip,
                                keyboardType: .numberPad,
                                textContentType: .postalCode
                            )
                        }

                        HStack(spacing: 12) {
                            AddressField(
                                title: "Province",
                                text: $formData.province,
                                textContentType: .addressState
                            )
                            AddressField(
                                title: "Country",
                                isRequired: true,
                                text: $formData.country,
                                textContentType: .countryName
                            )
                        }
                    }

                    Divider().overlay(Color("TintColor"))

                    AddressField(
                        title: "Phone",
                        text: $formData.phone,
                        keyboardType: .phonePad,
                        textContentType: .telephoneNumber
                    )
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color("BackgroundColor").ignoresSafeArea())
            .navigationTitle(isEditing ? "Edit Address" : "Add Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.secondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    if isEditing {
                        onEdit(formData)
                    } else {
                        onAdd(formData)
                    }
                    dismiss()
                } label: {
                    Text(isEditing ? "Save Changes" : "Save Address")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background {
                    if formData.isValid {
                        Color("PrimaryColor")
                    } else {
                        Color.gray.opacity(0.4)
                    }
                }
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
                .disabled(!formData.isValid)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .background(.ultraThinMaterial)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
