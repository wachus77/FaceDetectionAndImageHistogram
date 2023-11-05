//
//  AppFoundation.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

/// Protocol which will be used by almost all flow controllers in the application.
protocol AppFoundation {
    var openCVService: OpenCVWrapperProtocol { get }
}
