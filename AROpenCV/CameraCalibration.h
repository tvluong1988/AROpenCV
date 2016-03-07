//
//  CameraCalibration.h
//  AROpenCV
//
//  Created by Thinh Luong on 3/6/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

#ifndef CameraCalibration_h
#define CameraCalibration_h

#import <UIKit/UIKit.h>

struct CameraCalibration {
  CGFloat xDistortion;
  CGFloat yDistortion;
  CGFloat xCorrection;
  CGFloat yCorrection;
};

#endif /* CameraCalibration_h */
