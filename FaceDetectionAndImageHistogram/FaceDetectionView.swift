//
//  FaceDetectionView.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import AVFoundation

final class FaceDetectionView: BaseView<FaceDetectionViewModelGeneralProtocol> {
    
    // MARK: - Properties
    
    private(set) lazy var videoPreviewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession)
    private(set) var detectionOverlayLayer = CAShapeLayer()
    
    // MARK: - Methods
    
    func updateFrames() {
        let marginX: CGFloat = 50.0
        let marginY: CGFloat = 200.0
        let detectionOverlayRect = bounds.insetBy(dx: marginX, dy: marginY)
        detectionOverlayLayer.path = UIBezierPath(rect: detectionOverlayRect).cgPath
        
        videoPreviewLayer.frame = frame
    }
    
    func updateDetectionOverlayLayer(strokeColor: CGColor) {
        detectionOverlayLayer.strokeColor = strokeColor
    }
}

extension FaceDetectionView: ViewSetupable {
    
    /// - SeeAlso: ViewSetupable.setupProperties
    func setupProperties() {
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        detectionOverlayLayer.fillColor = UIColor.clear.cgColor
        detectionOverlayLayer.strokeColor = UIColor.red.cgColor
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        layer.addSublayer(videoPreviewLayer)
        layer.addSublayer(detectionOverlayLayer)
        updateFrames()
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {}
}
