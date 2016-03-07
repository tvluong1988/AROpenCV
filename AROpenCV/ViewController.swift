//
//  ViewController.swift
//  AROpenCV
//
//  Created by Thinh Luong on 3/3/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var cameraImageView: UIImageView!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var trackingHelperView: UIImageView!
  @IBOutlet weak var crossHairsView: UIImageView!
  
  
  // MARK: Actions
  @IBAction func shootButtonPressed(sender: UIButton) {
    print("Fire!")
    
    let targetHitPoint = arView.convertPoint(crossHairsView.center, fromView: view)
    let ring = arView.selectBestRing(targetHitPoint)
    
    switch ring {
    case 5:
      hitTargetWithPoint(.RingFive)
    case 4:
      hitTargetWithPoint(.RingFour)
    case 3:
      hitTargetWithPoint(.RingThree)
    case 2:
      hitTargetWithPoint(.RingTwo)
    case 1:
      hitTargetWithPoint(.RingOne)
    default:
      missTarget()
    }
  }
  
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    videoSource = VideoSource()
    videoSource.delegate = self
    videoSource.startCameraWithPosition(.Back)
    
    prepareSounds()
    
    patternDetector = PatternDetectorWrapper(image: targetImage!)
    let interval: NSTimeInterval = 1/20
    timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "updateTracking", userInfo: nil, repeats: true)
    //    timer = NSTimer(timeInterval: interval, target: self, selector: "updateTracking", userInfo: nil, repeats: true)
    
    // iPhone5 config
    cameraCalibration = CameraCalibration(xDistortion: 0.88, yDistortion: 0.675, xCorrection: 1.78, yCorrection: 1.295238095238095)
    
    // default config
    cameraCalibration = CameraCalibration(xDistortion: 0.8, yDistortion: 0.675, xCorrection: (16.0/11.0), yCorrection: 1.295238095238095)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    scoreLabel.text = score.description
    
    arView = ARView(size: targetImage!.size, calibration: cameraCalibration)
    view.addSubview(arView)
    arView.hide()
    
  }
  
  // MARK: Properties
  var videoSource: VideoSource!
  var score: Int = 0
  var explosionAudio: AVAudioPlayer!
  var shootAudio: AVAudioPlayer!
  var missedTargetAudio: AVAudioPlayer!
  var patternDetector: PatternDetectorWrapper!
  var timer: NSTimer?
  var arView: ARView!
  let targetImage = UIImage(named: "target")
  var cameraCalibration: CameraCalibration!
  
}

// MARK: - Tracking
extension ViewController {
  
  /**
   Update the trackingHelperView with openCV's debug image, check if the pattern is tracking and update the arView accordingly.
   */
  func updateTracking() {
    
    trackingHelperView.image = patternDetector.sampleImage()
    
    if patternDetector.isTracking() {
      print("Yes: \(patternDetector.matchValue())")
      
      let matchPoint = patternDetector.matchPoint()
      arView.center = CGPoint(
        x: cameraCalibration.xCorrection * matchPoint.x + targetImage!.size.width * 0.4,
        y: cameraCalibration.yCorrection * matchPoint.y + targetImage!.size.height * 0.35)
      
      arView.show()
    } else {
      print("No: \(patternDetector.matchValue())")
      
      arView.hide()
    }
  }
  
  /**
   Update score, play audio, and animate explosion.
   
   - parameter point: Point to be added
   */
  func hitTargetWithPoint(point: Point) {
    score += point.rawValue
    scoreLabel.text = score.description
    
    
    if let explosionImage = UIImage(named: "Explosion") {
      shootAudio.play()
      animateExplosion(explosionImage)
    }
  }
  
  /**
   Play missed audio.
   */
  func missTarget() {
    print("Missed target!")
    missedTargetAudio.play()
  }
  
  /**
   Animation an explosion with the given image.
   
   - parameter image: explosion image
   */
  func animateExplosion(image: UIImage) {
    let explosionView = UIImageView(image: image)
    explosionView.contentMode = .ScaleAspectFit
    explosionView.frame.size.width *= 3
    explosionView.frame.size.height *= 3
    
    explosionView.frame.origin = CGPoint(x: view.frame.midX - image.size.width * 1, y: view.frame.midY - image.size.height * 1)
    
    view.addSubview(explosionView)
    
    let duration: NSTimeInterval = 0.2
    let delay: NSTimeInterval = 0.02
    let option: UIViewAnimationOptions = .CurveEaseOut
    
    
    UIView.animateWithDuration(duration, delay: delay, options: option, animations: {
      self.explosionAudio.play()
      explosionView.alpha = 0
      
      }, completion: { _ in
        explosionView.removeFromSuperview()
    })
  }
  
  /**
   Load sounds into AVAudioPlayers.
   */
  func prepareSounds() {
    explosionAudio = AVAudioPlayer.initWithFile("explosion", type: "caf")
    explosionAudio.prepareToPlay()
    
    shootAudio = AVAudioPlayer.initWithFile("laser", type: "caf")
    shootAudio.prepareToPlay()
    
    missedTargetAudio = AVAudioPlayer.initWithFile("powerup", type: "caf")
    missedTargetAudio.prepareToPlay()
  }
}

// MARK: - VideoSourceDelegate
extension ViewController: VideoSourceDelegate {
  func frameReady(frame: VideoFrame) {
    dispatch_sync(dispatch_get_main_queue()) {
      if let cgiImage = self.createCGImageFromVideoFrame(frame) {
        let image = UIImage(CGImage: cgiImage)
        self.cameraImageView.image = image
      }
    }
    
    patternDetector.scanFrame(frame)
  }
  
  func createCGImageFromVideoFrame(frame: VideoFrame) -> CGImage? {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue
    
    let context = CGBitmapContextCreate(frame.data, frame.width, frame.height, 8, frame.stride, colorSpace, bitmapInfo)
    
    
    let image = CGBitmapContextCreateImage(context)
    
    return image
  }
}






































