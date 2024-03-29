import AVFoundation
import Photos
import UIKit

protocol PermissionManagerDelegate: AnyObject {
    func allowed(for sourceType: UIImagePickerController.SourceType)
    func denied(for sourceType: UIImagePickerController.SourceType)
}

final class PermissionManager {
    weak var delegate: PermissionManagerDelegate?
    
    func handleCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            self.delegate?.denied(for: .camera)
        case .authorized:
            self.delegate?.allowed(for: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    self.delegate?.allowed(for: .camera)
                } else {
                    self.delegate?.denied(for: .camera)
                }
            }
        @unknown default: break
        }
    }
    
    func handlePhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied, .restricted:
            self.delegate?.denied(for: .photoLibrary)
        case .authorized:
            self.delegate?.allowed(for: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
                if status == .authorized {
                    self.delegate?.allowed(for: .photoLibrary)
                } else {
                    self.delegate?.denied(for: .photoLibrary)
                }
            }
        case .limited:
            self.delegate?.allowed(for: .photoLibrary)
        @unknown default: break
        }
    }
    
}


