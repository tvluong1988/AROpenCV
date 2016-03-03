//
//  VideoFrame.swift
//  AROpenCV
//
//  Created by Thinh Luong on 3/3/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import Foundation


struct VideoFrame {
  let width: size_t
  let height: size_t
  let stride: size_t
  let data: UnsafeMutablePointer<Void>
  
}