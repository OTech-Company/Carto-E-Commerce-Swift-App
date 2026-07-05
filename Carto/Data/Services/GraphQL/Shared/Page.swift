//
//  Page.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

struct StorefrontPage<Element> {
    let items: [Element]
    let hasNextPage: Bool
    let endCursor: String?
}

extension StorefrontConnection {

    func toStorefrontPage<Domain>(
        _ transform: (Node) -> Domain
    ) -> StorefrontPage<Domain> {
        StorefrontPage(
            items: nodes.map(transform),
            hasNextPage: pageInfo.hasNextPage,
            endCursor: pageInfo.endCursor
        )
    }
}
