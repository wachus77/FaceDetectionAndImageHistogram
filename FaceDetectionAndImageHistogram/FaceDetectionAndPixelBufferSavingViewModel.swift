//
//  FaceDetectionAndPixelBufferSavingViewModel.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import AVFoundation
import Vision
import Combine

protocol FaceDetectionAndPixelBufferSavingViewModelProtocol: FaceDetectionViewModelGeneralProtocol {
    func setupVideoOutput(delegate: AVCaptureVideoDataOutputSampleBufferDelegate)
    func saveFaceImage(pixelBuffer: CVPixelBuffer, detectionOverlayLayerBoundingBox: CGRect, previewLayer: AVCaptureVideoPreviewLayer)
}

class FaceDetectionAndPixelBufferSavingViewModel: FaceDetectionViewModel, FaceDetectionAndPixelBufferSavingViewModelProtocol {
    
    // MARK: - Methods
    
    private let videoDataOutput = AVCaptureVideoDataOutput()

    // MARK: - Methods
    
    func setupVideoOutput(delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        guard captureSession.canAddOutput(videoDataOutput) else {
            print("Can not add AVCaptureVideoDataOutput.")
            return
        }
        
        captureSession.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        
        connection.videoOrientation = .portrait
    }
    
    func saveFaceImage(pixelBuffer: CVPixelBuffer, detectionOverlayLayerBoundingBox: CGRect, previewLayer: AVCaptureVideoPreviewLayer) {
        guard self.takenFaceImage == nil else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        let pixelBufferSize = CGSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        
        let transform = CGAffineTransform(scaleX: pixelBufferSize.width / previewLayer.bounds.width, y: pixelBufferSize.height / previewLayer.bounds.height)
        let transformedBoundingBox = detectionOverlayLayerBoundingBox.applying(transform)
        
        if let cgImage = context.createCGImage(ciImage, from: transformedBoundingBox) {
            let faceCrop = UIImage(cgImage: cgImage, scale: 1, orientation: .upMirrored)
            self.takenFaceImage = faceCrop
            if let histogramImage = openCVService.generateColorHistogram(for: faceCrop) {
                imageProcessedPublisher.send((faceCrop, histogramImage))
            }
        }
    }
}
