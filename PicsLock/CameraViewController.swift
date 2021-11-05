import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        
        _ = try? AVCaptureDeviceInput(device: backCamera)
    }
    
}
