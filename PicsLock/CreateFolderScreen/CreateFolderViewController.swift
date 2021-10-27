import UIKit

protocol CreateFolderDelegate: AnyObject {
  func didCreate()
}

final class CreateFolderViewController: UIViewController {
  private let fileService = FileService()
  weak var delegate: CreateFolderDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view = CreateFolderView()
    (view as? CreateFolderView)?.delegate = self
  }
}

extension CreateFolderViewController: CreateFolderViewDelegate {
  func didClose() {
    self.dismiss(animated: true)
  }
  
  func didEnter(folderName: String, codeHash: String?) {
    fileService.createFolder(folderName: folderName, codeHash: codeHash)
    delegate?.didCreate()
    self.dismiss(animated: true)
  }
}
