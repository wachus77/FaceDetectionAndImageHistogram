//
//  FaceDetectionViewModelGeneralProtocol.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import AVFoundation
import Combine
import Vision

protocol FaceDetectionViewModelGeneralProtocol {
    var captureSession: AVCaptureSession { get }

    var faceDetectionPublisher: PassthroughSubject<([VNFaceObservation], CVPixelBuffer), Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }
    var imageProcessedPublisher: PassthroughSubject<(UIImage, UIImage), Never> { get }
    
    func setupCameraInput()
    func startRunningCaptureSession()
    func detectFace(pixelBuffer: CVPixelBuffer)
    func updateFacePositionCorrectness(isCorrect: Bool)
    func clearCaptureSession()
}
