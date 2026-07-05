//
//  AddressField.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

struct AddressField: View {
    let title: String
    var isRequired: Bool = false
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(isRequired ? "\(title) *" : title)
                .font(.caption)
                .foregroundStyle(.secondary)
 
            TextField(title, text: $text)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .autocorrectionDisabled()
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isFocused ? Color("PrimaryColor") : Color(.systemGray5),
                            lineWidth: isFocused ? 1.5 : 1.0
                        )
                )
        }
    }
}
