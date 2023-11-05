//
//  DefaultAppFoundation.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

final class DefaultAppFoundation: AppFoundation {
    
    private(set) lazy var openCVService: OpenCVWrapperProtocol = {
        return OpenCVWrapper()
    }()
}
