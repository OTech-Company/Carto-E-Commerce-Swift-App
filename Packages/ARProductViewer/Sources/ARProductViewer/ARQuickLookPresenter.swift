//
//  ARQuickLookPresenter.swift
//  ARProductViewer
//
//  Created by Osama Hosam on 09/07/2026.
//


import UIKit
import ARKit
import QuickLook

public final class ARQuickLookPresenter: NSObject {
    private var modelURL: URL?
    private var onDismiss: (() -> Void)?

    nonisolated(unsafe) public static let shared = ARQuickLookPresenter()
    private override init() {}

    @MainActor public func present(modelURL: URL, from viewController: UIViewController, onDismiss: @escaping () -> Void = {}) {
        self.modelURL = modelURL
        self.onDismiss = onDismiss

        let controller = QLPreviewController()
        controller.dataSource = self
        controller.delegate = self
        viewController.present(controller, animated: true)
    }
}

extension ARQuickLookPresenter: QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

    public func previewController(_ controller: QLPreviewController,
                                   previewItemAt index: Int) -> QLPreviewItem {
        let item = ARQuickLookPreviewItem(fileAt: modelURL!)
        item.allowsContentScaling = true
        return item
    }

    public func previewControllerDidDismiss(_ controller: QLPreviewController) {
        onDismiss?()
    }
}
