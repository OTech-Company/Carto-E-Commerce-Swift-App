//
//  ARPreviewService.swift
//  ARProductViewer
//
//  Created by Osama Hosam on 09/07/2026.
//

	
import ARKit
import Foundation

public final class ARPreviewService: ARPreviewServicing {

    public init() {} // required - synthesized init is internal by default

    public func canPreviewAR(modelName: String) -> Bool {
        guard ARConfiguration.isSupported else { return false }
        return arModelURL(named: modelName) != nil
    }

    public func arModelURL(named modelName: String) -> URL? {
        Bundle.main.url(forResource: modelName, withExtension: "usdz")
    }
}
