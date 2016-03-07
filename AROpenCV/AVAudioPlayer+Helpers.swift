//
//  AVAudioPlayer+Helpers.swift
//  AROpenCV
//
//  Created by Thinh Luong on 3/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
  class func initWithFile(file: String, type: String) -> AVAudioPlayer?
  {
    let path = NSBundle.mainBundle().pathForResource(file, ofType: type)
    let url = NSURL.fileURLWithPath(path!)
    
    var audioPlayer: AVAudioPlayer?
    do {
      audioPlayer = try AVAudioPlayer(contentsOfURL: url)
    } catch let error as NSError {
      print(error)
      audioPlayer = nil
    }
    
    return audioPlayer
  }
}


