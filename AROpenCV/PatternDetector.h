//
//  PatternDetector.h
//  AROpenCV
//
//  Created by Thinh Luong on 3/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

#ifndef PatternDetector_h
#define PatternDetector_h

#include "VideoFrame.h"
#include <opencv2/opencv.hpp>

class PatternDetector
{
#pragma mark -
#pragma mark Public Interface
public:
  // (1) Constructor
  PatternDetector(const cv::Mat& pattern);
  
  // (2) Scan the input video frame
  void scanFrame(VideoFrame frame);
  
  // Peek inside the pattern detector to assist marker tracking
  const cv::Mat& sampleImage();
  
  // (3) Match APIs
  const cv::Point& matchPoint();
  float matchValue();
  float matchThresholdValue();
  
  // (4) Tracking API
  bool isTracking();
  
#pragma mark -
#pragma mark Private Members
private:
  // (5) Reference Marker Images
  cv::Mat m_patternImage;
  cv::Mat m_patternImageGray;
  cv::Mat m_patternImageGrayScaled;
  cv::Mat m_sampleImage;
  
  // (6) Supporting Members
  cv::Point m_matchPoint;
  int m_matchMethod;
  float m_matchValue;
  float m_matchThresholdValue;
  float m_scaleFactor;
};

#endif /* PatternDetector_h */

