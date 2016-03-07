//
//  UIImage+OpenCV.m
//  AROpenCV
//
//  Created by Thinh Luong on 3/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

#import "UIImage+OpenCV.h"

@implementation UIImage (OpenCV)

- (id)initWithCVMat:(const cv::Mat&)cvMat
{
  NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
  CGColorSpaceRef colorSpace;
  
  if (cvMat.elemSize() == 1) {
    colorSpace = CGColorSpaceCreateDeviceGray();
  } else {
    colorSpace = CGColorSpaceCreateDeviceRGB();
  }
  
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  
  // Creating CGImage from cv::Mat
  CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                      cvMat.rows,                                 //height
                                      8,                                          //bits per component
                                      8 * cvMat.elemSize(),                       //bits per pixel
                                      cvMat.step[0],                              //bytesPerRow
                                      colorSpace,                                 //colorspace
                                      kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                      provider,                                   //CGDataProviderRef
                                      NULL,                                       //decode
                                      false,                                      //should interpolate
                                      kCGRenderingIntentDefault                   //intent
                                      );
  
  // Getting UIImage from CGImage
  self = [self initWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);
  
  return self;
}

+ (UIImage *)imageWithCVMat:(const cv::Mat &)cvMat {
  return [[UIImage alloc] initWithCVMat:cvMat];
}

- (cv::Mat)toCVMat {
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
  CGFloat cols = self.size.width;
  CGFloat rows = self.size.height;
  
  cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
  
  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags
  
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
  CGContextRelease(contextRef);
  
  return cvMat;
}

@end

