//
//  CMSampleBuffer+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

import Vision
import CoreMedia

public extension CMSampleBuffer {
    var ft_pixelBuffer: CVPixelBuffer? { CMSampleBufferGetImageBuffer(self) }
    
    var ft_timestamp: TimeInterval {
        CMSampleBufferGetOutputPresentationTimeStamp(self).seconds
    }
    
    // Shorthand for FaceAttributeClassifier to easily generate options
    var ft_imageRequestHandlerOptions: [VNImageOption : AnyObject] {
        var requestHandlerOptions: [VNImageOption: AnyObject] = [:]
        
        let cameraIntrinsicData = CMGetAttachment(self, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil)
        if cameraIntrinsicData != nil {
            requestHandlerOptions[VNImageOption.cameraIntrinsics] = cameraIntrinsicData
        }
        
        return requestHandlerOptions
    }
}
