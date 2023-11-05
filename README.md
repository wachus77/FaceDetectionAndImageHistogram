# Face Detection and Image Histogram

## Project Objective

The goal of this project is to create an iOS application that allows for automatic capturing of a selfie using the front-facing (selfie) camera. The app should provide a user experience as follows:

1. **Face Positioning Guide:**
   - A rectangle is displayed on the screen within which the user is supposed to position their face along with a live preview from the selfie camera. As long as the face is positioned outside the expected area, the rectangle is red.

2. **Automatic Capture:**
   - Once the face is correctly positioned within the bounds of the rectangle, its color changes to green, and the photo is taken automatically without any user interaction required.

3. **Post-Capture Display:**
   - After the photo is taken, the captured image is displayed on the screen along with its color histogram.
   
   To detect faces, the `Vision` framework was used, and to draw the histogram, `OpenCV` was utilized.

## Setup Instructions

This project requires the `opencv2.framework` to function correctly. Please follow the steps below to set up the project on your local machine.

1. **Download `opencv2.framework`:**
   - Obtain the framework from the specified location: https://github.com/opencv/opencv/releases/download/4.8.1/opencv-4.8.1-ios-framework.zip

2. **Unpack the Framework:**
   - Once downloaded, unzip the framework from its archive.

3. **Create Frameworks Directory:**
   - Navigate to the root directory of the project, `/FaceDetectionAndImageHistogram/`.
   - Create a new folder named `Frameworks`.

4. **Copy Framework:**
   - Copy the `opencv2.framework` to the `/FaceDetectionAndImageHistogram/Frameworks/` directory you just created.

After completing these steps, the project should be ready to build and run using Xcode.

## Usage - Additional Information

This project includes an implementation of automatic selfie capture using face detection. There are two versions available in this project:

1. **Version 1:** Utilizes `CVPixelBuffer` obtained from `captureOutput` of `AVCaptureVideoDataOutputSampleBufferDelegate` to create a selfie.

2. **Version 2:** Makes use of `AVCapturePhoto` obtained from `photoOutput` of `AVCapturePhotoCaptureDelegate` to create a selfie.

By default, Version 1 is set up and ready to use. If you wish to test Version 2, you need to modify the `AppFlowController` file. Specifically, in the `start` method, replace `displayFaceDetectionAndPixelBufferSavingScreen()` with `displayFaceDetectionAndCapturePhotoSavingScreen()`.
