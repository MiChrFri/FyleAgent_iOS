//
//  CameraViewController.swift
//  PicsLock
//
//  Created by Michael Frick on 23/11/2019.
//  Copyright © 2019 Michael Frick. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
  
  var captureSession: AVCaptureSession!
  var stillImageOutput: AVCapturePhotoOutput!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      captureSession = AVCaptureSession()
      captureSession.sessionPreset = .medium
    
    
    guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
    }
    
    do {
        let input = try AVCaptureDeviceInput(device: backCamera)
        //Step 9
    }
    catch let error  {
        print("Error Unable to initialize back camera:  \(error.localizedDescription)")
    }
  }
  
}
