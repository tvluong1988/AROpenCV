//
//  UIImage+OpenCV.h
//  AROpenCV
//
//  Created by Thinh Luong on 3/5/16.  var explosionAudio: AVAudioPlayer!
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

#ifndef UIImage_OpenCV_h
#define UIImage_OpenCV_h

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface UIImage (OpenCV)

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
- (id)initWithCVMat:(const cv::Mat&)cvMat;

- (cv::Mat)toCVMat;

@end

#endif /* UIImage_OpenCV_h */
