//
//  CGRect+Extensions.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

extension CGRect {
    // Check if this rectangle is almost centered in another rectangle
    func isAlmostCentered(in outerRect: CGRect, withTolerance tolerance: CGFloat) -> Bool {
        // Calculate the centers of each rectangle
        let innerCenter = CGPoint(x: self.midX, y: self.midY)
        let outerCenter = CGPoint(x: outerRect.midX, y: outerRect.midY)
        
        // Calculate the difference between the centers
        let deltaX = abs(innerCenter.x - outerCenter.x)
        let deltaY = abs(innerCenter.y - outerCenter.y)
        
        // If the difference is within the tolerance, it's almost centered
        return deltaX <= tolerance && deltaY <= tolerance
    }
}

extension CGRect {
    /// Resizes the rectangle by a given percentage.
    /// - Parameters:
    ///   - widthScale: The percentage to inflate or deflate the width of the rectangle.
    ///   - heightScale: The percentage to inflate or deflate the height of the rectangle.
    /// - Returns: A new `CGRect` instance with the adjusted dimensions.
    func resizedBy(widthScale: CGFloat, heightScale: CGFloat) -> CGRect {
        let newWidth = self.width + self.width * widthScale
        let newHeight = self.height + self.height * heightScale
        let newX = self.origin.x - (newWidth - self.width) / 2.0
        let newY = self.origin.y - (newHeight - self.height) / 2.0
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
    
    /// Inflates the rectangle by a given percentage.
    /// - Parameters:
    ///   - dx: The percentage to inflate the width of the rectangle.
    ///   - dy: The percentage to inflate the height of the rectangle.
    /// - Returns: A new `CGRect` instance with the adjusted dimensions.
    func inflatedBy(dx: CGFloat, dy: CGFloat) -> CGRect {
        return self.insetBy(dx: -dx * self.width, dy: -dy * self.height)
    }
}
