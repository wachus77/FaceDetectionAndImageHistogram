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
    func handleTakenPhoto(photo: AVCapturePhoto) async
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
    
    func handleTakenPhoto(photo: AVCapturePhoto) async {
        guard self.takenFaceImage == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        self.takenFaceImage = image
        if let histogramImage = openCVService.generateColorHistogram(for: image) {
            imageProcessedPublisher.send((image, histogramImage))
        }
    }
}
