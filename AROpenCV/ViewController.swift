//
//  ViewController.swift
//  AROpenCV
//
//  Created by Thinh Luong on 3/3/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var cameraImageView: UIImageView!
  
  // MARK: Actions
  @IBAction func shootButtonPressed(sender: UIButton) {
    print("Fire!")
  }
  
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    videoSource = VideoSource()
    videoSource.delegate = self
    videoSource.startCameraWithPosition(.Back)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  // MARK: Properties
  var videoSource: VideoSource!
}

extension ViewController: VideoSourceDelegate {
  func frameReady(frame: VideoFrame) {
    dispatch_sync(dispatch_get_main_queue()) {
      if let cgiImage = self.createCGImageFromVideoFrame(frame) {
        let image = UIImage(CGImage: cgiImage)
        self.cameraImageView.image = image
      }
    }
  }
  
  func createCGImageFromVideoFrame(frame: VideoFrame) -> CGImage? {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue
    
    let context = CGBitmapContextCreate(frame.data, frame.width, frame.height, 8, frame.stride, colorSpace, bitmapInfo)
    
    
    let image = CGBitmapContextCreateImage(context)
    
    return image
  }
}






































