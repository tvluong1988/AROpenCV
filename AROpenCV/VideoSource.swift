//
//  VideoSource.swift
//  AROpenCV
//
//  Created by Thinh Luong on 3/3/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import AVFoundation

protocol VideoSourceDelegate: class {
  func frameReady(frame: VideoFrame)
}

class VideoSource: NSObject {
  
  // MARK: Lifecycle
  override init() {
    captureSession = AVCaptureSession()
    
    if captureSession.canSetSessionPreset(AVCaptureSessionPreset640x480) {
      captureSession.sessionPreset = AVCaptureSessionPreset640x480
      print("Capturing video at \(captureSession.sessionPreset)")
    } else {
      print("Could not configure AVCaptureSession video input")
    }
    
  }
  
  deinit {
    captureSession.stopRunning()
  }
  
  
  // MARK: Properties
  var captureSession: AVCaptureSession!
  var deviceInput: AVCaptureDeviceInput?
  weak var delegate: VideoSourceDelegate?
  
}

extension VideoSource {
  
  func startCameraWithPosition(position: AVCaptureDevicePosition) -> Bool {
    guard let camera = getCameraWithPosition(.Back) else {
      return false
    }
    
    
    if let input = try? AVCaptureDeviceInput(device: camera) {
      deviceInput = input
    } else {
      print("Could not open input port for device \(camera)")
      return false
    }
    
    do {
      deviceInput = try AVCaptureDeviceInput(device: camera)
    } catch _ {
      print("Could not open input port for device \(camera)")
      return false
    }
    
    if captureSession.canAddInput(deviceInput) {
      captureSession.addInput(deviceInput)
    } else {
      print("Could not add input port to capture session \(captureSession)")
      return false
    }
    
    addVideoDataOutput()
    
    captureSession.startRunning()
    
    return true
    
  }
  
  func addVideoDataOutput() {
    let captureOutput = AVCaptureVideoDataOutput()
    captureOutput.alwaysDiscardsLateVideoFrames = true
    
    // The sample buffer delegate requires a serial dispatch queue
    let queue = dispatch_queue_create("com.tvluong.AROpenCV", DISPATCH_QUEUE_SERIAL)
    captureOutput.setSampleBufferDelegate(self, queue: queue)
    
    // Define the pixel format for the video data output
    let key = kCVPixelBufferPixelFormatTypeKey as NSString
    let value = NSNumber(unsignedInt: kCVPixelFormatType_32BGRA)
    let settings = NSDictionary(object: value, forKey: key)
    
    captureOutput.videoSettings = settings as [NSObject : AnyObject]
    
    captureSession.addOutput(captureOutput)
    
    // Set portrait orientation
    let connection = captureOutput.connectionWithMediaType(AVMediaTypeVideo)
    connection.videoOrientation = .LandscapeRight
  }
  
  func getCameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
    let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
    
    for device in devices {
      if device.position == position {
        return device
      }
    }
    
    return nil
  }
}

extension VideoSource: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
    
    // Convert CMSampleBufferRef to CVImageBufferRef
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    
    // Lock pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly)
    
    // Construct VideoFrame struct
    //    let pointerConversion = UnsafeMutablePointer<CUnsignedChar>(CVPixelBufferGetBaseAddress(imageBuffer))
    
    let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
    let width: size_t = CVPixelBufferGetWidth(imageBuffer)
    let height: size_t = CVPixelBufferGetHeight(imageBuffer)
    let stride: size_t = CVPixelBufferGetBytesPerRow(imageBuffer)
    
    let frame = VideoFrame(width: width, height: height, stride: stride, data: baseAddress)
    
    // Dispatch VideoFrame to VideoSource delegate
    delegate?.frameReady(frame)
    
    // Unlock pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
  }
}



























