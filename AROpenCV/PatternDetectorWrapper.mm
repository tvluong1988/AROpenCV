//
//  PatternDetectorWrapper.m
//  AROpenCV
//
//  Created by Thinh Luong on 3/6/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

#import "PatternDetectorWrapper.h"
#import "PatternDetector.h"
#import "UIImage+OpenCV.h"

@interface PatternDetectorWrapper ()
{
  
  PatternDetector *m_detector;
  
}

@end

@implementation PatternDetectorWrapper

- (id)initWithImage:(const UIImage *)image {
  self = [super init];
  
  if (self) {
    m_detector = new PatternDetector([image toCVMat]);
  }
  
  return self;
}

-(void)scanFrame:(struct VideoFrame)frame {
  m_detector->scanFrame(frame);
}

-(UIImage*)sampleImage {
  return [[UIImage alloc] initWithCVMat:m_detector->sampleImage()];
}

-(CGPoint)matchPoint {
  
  int x = m_detector->matchPoint().x;
  int y = m_detector->matchPoint().y;
  CGPoint point = CGPointMake(x, y);
  
  return point;
  
}

-(BOOL)isTracking {
  return m_detector->isTracking();
}

-(CGFloat)matchValue {
  return m_detector->matchValue();
}

-(CGFloat)matchThresholdValue {
  return m_detector->matchThresholdValue();
}



@end

















