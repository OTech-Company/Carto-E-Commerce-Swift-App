//
//  AddressCard.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

struct AddressCard: View {
    let address: CustomerAddress

    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    var onSetDefault: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            Divider()
            locationInfo

            if onEdit != nil || onDelete != nil {
                actionButtons
            }

            if !address.isDefault, let onSetDefault = onSetDefault {
                setDefaultButton(action: onSetDefault)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    address.isDefault
                        ? Color("PrimaryColor").opacity(0.5) : Color.clear,
                    lineWidth: address.isDefault ? 1.5 : 0
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    // MARK: Header
    private var header: some View {
        HStack(alignment: .top) {
            Text(
                address.address1
            )
            .font(.headline)
            .foregroundColor(.primary)

            Spacer()

            if address.isDefault {
                defaultBadge
            }
        }
    }

    private var defaultBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 10, weight: .bold))
            Text("Default")
                .font(.caption2.weight(.semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color("PrimaryColor"))
        .foregroundColor(.white)
        .clipShape(Capsule())
    }

    // MARK: Location info
    private var locationInfo: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color("PrimaryColor"))
                .frame(width: 25, height: 25)
                .background(Color("TintColor"))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(
                    address.address2 != nil
                        ? "\(address.address2!), \(address.city)"
                        : address.city
                )
                .font(.subheadline.weight(.medium))
                .foregroundColor(.primary)

                Text(
                    address.province != ""
                        ? "\(address.province), \(address.country)"
                        : address.country
                )
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
    }

    // MARK: Edit / Delete actions
    private var actionButtons: some View {
        HStack(spacing: 16) {
            if let onEdit = onEdit {
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                        .font(.caption.weight(.semibold))
                }
                .foregroundColor(Color("PrimaryColor"))
            }

            Spacer()

            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .font(.caption.weight(.semibold))
                }
                .foregroundColor(.red)
            }
        }
        .padding(.top, 2)
    }

    // MARK: Set as Default action
    private func setDefaultButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text("Set as Default")
                .font(.caption.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .foregroundColor(Color("PrimaryColor"))
        .background(Color("TintColor"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.top, 4)
    }
}
