//
//  ImgSearch+Extensions.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//

import UIKit
import Vision

extension ImageSearchRepositoryImpl {

    /// Generates a Vision feature print for an image.
    /// This feature print can later be compared with another image using
    /// `computeDistance(_:to:)`.
    func extractFeature(from image: UIImage) -> VNFeaturePrintObservation? {

        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("❌ Failed to convert UIImage to JPEG data.")
            return nil
        }

        let request = VNGenerateImageFeaturePrintRequest()
        let handler = VNImageRequestHandler(
            data: imageData,
            options: [:]
        )

        do {
            try handler.perform([request])

            guard let feature = request.results?.first as? VNFeaturePrintObservation else {
                print("❌ Vision did not generate a feature print.")
                return nil
            }

            return feature
        } catch {
            print("❌ Vision error: \(error)")
            return nil
        }
    }

    /// Computes the similarity distance between two feature prints.
    /// Smaller values indicate more similar images.
    func distance(
        between first: VNFeaturePrintObservation,
        and second: VNFeaturePrintObservation
    ) -> Float? {

        var distance: Float = 0

        do {
            try first.computeDistance(
                &distance,
                to: second
            )

            return distance
        } catch {
            print("❌ Failed to compute image distance: \(error)")
            return nil
        }
    }
}
