//
//  OpenCVWrapper.h
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 04/11/2023.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OpenCVWrapperProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject <OpenCVWrapperProtocol>

- (UIImage *)generateColorHistogramForImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
