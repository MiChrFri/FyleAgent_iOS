import UIKit

struct ImageProvider {
  func pickerController(from source: UIImagePickerController.SourceType) -> UIImagePickerController? {
    guard UIImagePickerController.isSourceTypeAvailable(source) else { return nil }
    var pickerController: UIImagePickerController?
    DispatchQueue.main.async {
      pickerController = UIImagePickerController()
    }
    
    pickerController?.sourceType = source
    pickerController?.allowsEditing = false
    return pickerController
  }
}
