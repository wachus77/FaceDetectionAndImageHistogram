//
//  OpenCVWrapper.m
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 04/11/2023.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"

using namespace cv;

@implementation OpenCVWrapper

- (UIImage *)generateColorHistogramForImage:(UIImage *)image {
    // Convert UIImage to cv::Mat
    Mat srcMat;
    UIImageToMat(image, srcMat, false);
    
    if (srcMat.empty()) {
        NSLog(@"Error: Image conversion to cv::Mat resulted in an empty matrix.");
        return nil;
    }
    
    cv::Mat colorMat;
    
    switch (srcMat.channels()) {
        case 1:
            // Convert grayscale to color
            cv::cvtColor(srcMat, colorMat, cv::COLOR_GRAY2BGR);
            break;
        case 3:
            // Already a color image
            colorMat = srcMat;
            break;
        case 4:
            // Convert RGBA to BGR
            cv::cvtColor(srcMat, colorMat, cv::COLOR_RGBA2BGR);
            break;
        default:
            NSLog(@"Error: The image has an unsupported number of channels.");
            return nil;
    }
    
    // Separate the image in 3 places ( B, G and R )
    std::vector<Mat> bgr_planes;
    split(srcMat, bgr_planes);
    
    // Establish the number of bins
    int histSize = 256;
    
    // Set the ranges ( for B,G,R) )
    float range[] = { 0, 256 };
    const float* histRange = { range };
    
    bool uniform = true;
    bool accumulate = false;
    
    Mat b_hist, g_hist, r_hist;
    
    // Compute the histograms:
    calcHist(&bgr_planes[0], 1, 0, Mat(), b_hist, 1, &histSize, &histRange, uniform, accumulate);
    calcHist(&bgr_planes[1], 1, 0, Mat(), g_hist, 1, &histSize, &histRange, uniform, accumulate);
    calcHist(&bgr_planes[2], 1, 0, Mat(), r_hist, 1, &histSize, &histRange, uniform, accumulate);
    
    // Draw the histograms for B, G and R
    int hist_w = 512; // Width of the histogram image
    int hist_h = 400; // Height of the histogram image
    int bin_w = cvRound((double)hist_w / histSize);
    
    Mat histImage(hist_h, hist_w, CV_8UC3, Scalar(0,0,0));
    
    // Normalize the result to [ 0, histImage.rows ]
    normalize(b_hist, b_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat());
    normalize(g_hist, g_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat());
    normalize(r_hist, r_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat());
    
    // Draw for each channel
    for(int i = 1; i < histSize; i++) {
        line(histImage, cv::Point(bin_w*(i-1), hist_h - cvRound(b_hist.at<float>(i-1))),
             cv::Point(bin_w*(i), hist_h - cvRound(b_hist.at<float>(i))),
             Scalar(255, 0, 0), 2, 8, 0);
        line(histImage, cv::Point(bin_w*(i-1), hist_h - cvRound(g_hist.at<float>(i-1))),
             cv::Point(bin_w*(i), hist_h - cvRound(g_hist.at<float>(i))),
             Scalar(0, 255, 0), 2, 8, 0);
        line(histImage, cv::Point(bin_w*(i-1), hist_h - cvRound(r_hist.at<float>(i-1))),
             cv::Point(bin_w*(i), hist_h - cvRound(r_hist.at<float>(i))),
             Scalar(0, 0, 255), 2, 8, 0);
    }
    
    // Convert cv::Mat back to UIImage
    UIImage *histogramImage = MatToUIImage(histImage);
    return histogramImage;
}

@end
