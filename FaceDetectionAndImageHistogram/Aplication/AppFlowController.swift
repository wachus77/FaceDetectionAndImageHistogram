//
//  AppFlowController.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import UIKit

final class AppFlowController {
    // MARK: Properties

    private var window: UIWindow

    /// Class that provides easy access to common dependencies.
    private let appFoundation: AppFoundation

    // MARK: Initializer

    /// Initializes an instance of the receiver.
    ///
    /// - Parameters:
    ///   - appFoundation: Provides easy access to common dependencies
    ///   - window: Application main window
    init(appFoundation: AppFoundation, window: UIWindow) {
        self.appFoundation = appFoundation
        self.window = window
    }

    // MARK: Functions

    /// Function starts work of AppFlowController.
    func start() {
        displayFaceDetectionAndPixelBufferSavingScreen()
        window.makeKeyAndVisible()
    }

    private func displayFaceDetectionAndCapturePhotoSavingScreen() {
        let viewModel = FaceDetectionAndCapturePhotoSavingViewModel(openCVService: appFoundation.openCVService)
        let controller = FaceDetectionAndCapturePhotoSavingViewController(view: FaceDetectionView(viewModel: viewModel), viewModel: viewModel)
        window.rootViewController = controller
    }
    
    private func displayFaceDetectionAndPixelBufferSavingScreen() {
        let viewModel = FaceDetectionAndPixelBufferSavingViewModel(openCVService: appFoundation.openCVService)
        let controller = FaceDetectionAndPixelBufferSavingViewController(view: FaceDetectionView(viewModel: viewModel), viewModel: viewModel)
        window.rootViewController = controller
    }
}
