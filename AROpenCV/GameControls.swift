//
//  GameControls.swift
//  AROpenCV
//
//  Created by Thinh Luong on 3/3/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import Foundation

func selectRandomRing() -> Int {
  let random1 = arc4random_uniform(100)
  
  switch random1 {
  case 1...50:
    return 0
    
  default:
    let random2 = arc4random_uniform(100)
    
    switch random2 {
    case 1...20:
      return 1
    case 21...40:
      return 2
    case 41...60:
      return 3
    case 61...80:
      return 4
    default: return 5
    }
  }
}

enum Point: Int {
  case RingOne = 50
  case RingTwo = 100
  case RingThree = 250
  case RingFour = 500
  case RingFive = 1000
}

































