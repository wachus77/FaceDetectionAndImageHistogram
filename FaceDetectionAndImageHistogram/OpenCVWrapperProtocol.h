//
//  OpenCVWrapperProtocol.h
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

#import <UIKit/UIKit.h>

@protocol OpenCVWrapperProtocol <NSObject>

- (UIImage *)generateColorHistogramForImage:(UIImage *)image;

@end
