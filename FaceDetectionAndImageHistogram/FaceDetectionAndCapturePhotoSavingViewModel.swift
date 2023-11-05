//
//  FaceDetectionAndCapturePhotoSavingViewModel.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import AVFoundation

protocol FaceDetectionAndCapturePhotoSavingViewModelProtocol: FaceDetectionViewModelGeneralProtocol {
    func setupPhotoOutput()
    func setupVideoOutput(delegate: AVCaptureVideoDataOutputSampleBufferDelegate)
    func takePicture(delegate: AVCapturePhotoCaptureDelegate)
    func createFaceImageAndHistogram(photo: AVCapturePhoto) async -> (takenImage: UIImage?, histogram: UIImage?)
}

class FaceDetectionAndCapturePhotoSavingViewModel: FaceDetectionAndPixelBufferSavingViewModel, FaceDetectionAndCapturePhotoSavingViewModelProtocol {
    
    // MARK: - Properties
    
    private let photoDataOutput = AVCapturePhotoOutput()
    
    // MARK: - Methods
    
    func setupPhotoOutput() {
        photoDataOutput.isHighResolutionCaptureEnabled = true
        guard captureSession.canAddOutput(photoDataOutput) else {
            print("Can not add AVCapturePhotoDataOutput.")
            return
        }
        captureSession.addOutput(photoDataOutput)
    }
    
    func takePicture(delegate: AVCapturePhotoCaptureDelegate) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        photoDataOutput.capturePhoto(with: settings, delegate: delegate)
    }
    
    func createFaceImageAndHistogram(photo: AVCapturePhoto) async -> (takenImage: UIImage?, histogram: UIImage?) {
        guard self.takenFaceImage == nil else { return (nil, nil) }
        guard let imageData = photo.fileDataRepresentation() else { return (nil, nil)  }
        guard let image = UIImage(data: imageData) else { return (nil, nil)  }
        self.takenFaceImage = image
        if let histogramImage = openCVService.generateColorHistogram(for: image) {
            return (image, histogramImage)
        }
        return (nil, nil)
    }
}
