//
//  CVPixelBuffer+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import CoreVideo
import UIKit

extension CVPixelBuffer {
    func ft_imageWithContext(_ ciContext: CIContext) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: self)
        guard let cgImage = ciContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
