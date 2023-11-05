//
//  FaceDetectionAndCapturePhotoSavingViewController.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import Vision
import AVFoundation
import Combine

class FaceDetectionAndCapturePhotoSavingViewController: BaseViewController<FaceDetectionView, FaceDetectionAndCapturePhotoSavingViewModelProtocol> {
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    
    override func setupView() {
        super.setupView()
        setupViewModel()
        customView.layoutIfNeeded()
        viewModel.startRunningCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.updateFrames()
    }
    
    deinit {
        viewModel.clearCaptureSession()
    }
    
    // MARK: - Methods
    
    private func setupViewModel() {
        viewModel.setupCameraInput()
        viewModel.setupVideoOutput(delegate: self)
        viewModel.setupPhotoOutput()
        
        viewModel.faceDetectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] observations, pixelBuffer in
                self?.checkFacePositionAndUpdateFaceDetectionOverlay(observations: observations, pixelBuffer: pixelBuffer)
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                // Handle any errors, perhaps by showing an alert
            }
            .store(in: &cancellables)
        
        viewModel.imageProcessedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] faceCrop, histogramImage in
                self?.viewModel.captureSession.stopRunning()
                self?.presentImageViewController(with: faceCrop, histogram: histogramImage)
            }
            .store(in: &cancellables)
    }
    
    private func presentImageViewController(with faceCrop: UIImage, histogram: UIImage) {
        let delayTime = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            let imageVC = ImageViewController()
            imageVC.topImage = faceCrop
            imageVC.bottomImage = histogram
            
            self.present(imageVC, animated: true)
        }
    }
    
    private func checkFacePositionAndUpdateFaceDetectionOverlay(observations: [VNFaceObservation], pixelBuffer: CVPixelBuffer) {
        observations.forEach { observation in
            let faceBoundingBoxOnScreen = customView.videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: observation.boundingBox).resizedBy(widthScale: 0.1, heightScale: 0.1)
            let detectionOverlayBoundingBox = customView.detectionOverlayLayer.path!.boundingBox
            if detectionOverlayBoundingBox.contains(faceBoundingBoxOnScreen), faceBoundingBoxOnScreen.isAlmostCentered(in: detectionOverlayBoundingBox, withTolerance: 25) {
                customView.updateDetectionOverlayLayer(strokeColor: UIColor.green.cgColor)
                viewModel.takePicture(delegate: self)
            }
        }
    }
    
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension FaceDetectionAndCapturePhotoSavingViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("Unable to get image from the sample buffer")
            return
        }
        viewModel.detectFace(pixelBuffer: pixelBuffer)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension FaceDetectionAndCapturePhotoSavingViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        viewModel.handleTakenPhoto(photo: photo)
    }
}
