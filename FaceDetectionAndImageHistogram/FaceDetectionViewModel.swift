//
//  FaceDetectionViewModel.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import AVFoundation
import Vision
import Combine

class FaceDetectionViewModel: FaceDetectionViewModelGeneralProtocol {
    
    // MARK: - Properties
    
    let openCVService: OpenCVWrapperProtocol
    let captureSession = AVCaptureSession()
    var takenFaceImage: UIImage?
    
    // Publishers
    var faceDetectionPublisher = PassthroughSubject<([VNFaceObservation], CVPixelBuffer), Never>()
    var errorPublisher = PassthroughSubject<Error, Never>()
    var imageProcessedPublisher = PassthroughSubject<(UIImage, UIImage), Never>()
    
    // MARK: Init
    
    init(openCVService: OpenCVWrapperProtocol) {
        self.openCVService = openCVService
    }
    
    // MARK: - Methods
    
    func setupCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
            fatalError("No camera detected. Please use a real camera, not a simulator.")
        }
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: device) else {
            fatalError("Cannot create camera input")
        }
        captureSession.addInput(cameraInput)
    }
    
    func startRunningCaptureSession() {
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func detectFace(pixelBuffer: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
            if let error = error {
                self?.errorPublisher.send(error)
                return
            }
            
            guard let observations = request.results as? [VNFaceObservation] else { return }
            self?.faceDetectionPublisher.send((observations, pixelBuffer))
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:])
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
            errorPublisher.send(error)
        }
    }
    
    func clearCaptureSession() {
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        for output in captureSession.outputs {
            captureSession.removeOutput(output)
        }
    }
}
