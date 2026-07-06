//
//  AddressFormBottomSheet.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

struct AddressFormBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var formData: CustomerAddress

    private let isEditing: Bool
    private let onAdd: (CustomerAddress) -> Void
    private let onEdit: (CustomerAddress) -> Void

    init(
        address: CustomerAddress? = nil,
        onAdd: @escaping (CustomerAddress) -> Void,
        onEdit: @escaping (CustomerAddress) -> Void
    ) {
        _formData = State(initialValue: address ?? CustomerAddress())
        self.isEditing = address != nil
        self.onAdd = onAdd
        self.onEdit = onEdit
    }
    
    let countries = Locale.Region.isoRegions
        .compactMap { region in
            Locale.current.localizedString(forRegionCode: region.identifier)
        }
        .sorted()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    // MARK: - Personal Info
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

                    AddressField(
                        title: "Company",
                        text: optionalBinding($formData.company),
                        textContentType: .organizationName
                    )

                    Divider().overlay(Color("TintColor"))
                        .padding(.vertical, 12)

                    // MARK: - Address Info
                    AddressField(
                        title: "Address",
                        isRequired: true,
                        text: $formData.address1,
                        textContentType: .streetAddressLine1
                    )

                    AddressField(
                        title: "Apt, suite, etc.",
                        text: optionalBinding($formData.address2),
                        textContentType: .streetAddressLine2
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
                        
                        CountryField(
                            title: "Country",
                            countries: countries,
                            selectedCountry: $formData.country
                        )
                    }

                    Divider().overlay(Color("TintColor"))
                        .padding(.vertical, 12)

                    // MARK: - Contact Info
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

    // MARK: - Helpers
    private func optionalBinding(_ binding: Binding<String?>) -> Binding<String> {
        Binding<String>(
            get: { binding.wrappedValue ?? "" },
            set: { binding.wrappedValue = $0.isEmpty ? nil : $0 }
        )
    }
}
