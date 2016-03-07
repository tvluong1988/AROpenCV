//
//  VideoFrameObjC++.h
//  AROpenCV
//
//  Created by Thinh Luong on 3/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

#ifndef VideoFrame_h
#define VideoFrame_h

//#include <cstddef>

#include <stddef.h>

struct VideoFrame
{
  size_t width;
  size_t height;
  size_t stride;
  
  unsigned char * data;
};

#endif /* VideoFrame_h */
