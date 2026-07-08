//
//  CountryFeild.swift
//  Carto
//
//  Created by Nadin Ahmed on 06/07/2026.
//

import SwiftUI

struct CountryField: View {
    let title: String
    let countries: [String]

    @Binding var selectedCountry: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker(title, selection: $selectedCountry) {
                Text("select_country_placeholder").tag("")

                ForEach(countries, id: \.self) { country in
                    Text(country)
                        .tag(country)
                }
            }
            .pickerStyle(.menu)
            .padding(4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .tint(.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5))
            )
        }
    }
}
