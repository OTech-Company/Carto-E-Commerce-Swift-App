//
//  ARPreviewServicing.swift
//  ARProductViewer
//
//  Created by Osama Hosam on 09/07/2026.
//


import Foundation

public protocol ARPreviewServicing {
    func canPreviewAR(modelName: String) -> Bool
    func arModelURL(named modelName: String) -> URL?
}