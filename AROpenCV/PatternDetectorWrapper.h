//
//  PatternDetectorWrapper.h
//  AROpenCV
//
//  Created by Thinh Luong on 3/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

#ifndef PatternDetectorWrapper_h
#define PatternDetectorWrapper_h


#import "VideoFrame.h"
#import <UIKit/UIKit.h>

@interface PatternDetectorWrapper : NSObject

- (id)initWithImage:(const UIImage*)image;
- (void)scanFrame:(struct VideoFrame)frame;

- (UIImage*)sampleImage;

- (BOOL)isTracking;

- (CGPoint)matchPoint;
- (CGFloat)matchValue;
- (CGFloat)matchThresholdValue;

@end

#endif /* PatternDetectorWrapper_h */
