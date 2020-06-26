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
    
    _ = try? AVCaptureDeviceInput(device: backCamera)
  }
  
}
