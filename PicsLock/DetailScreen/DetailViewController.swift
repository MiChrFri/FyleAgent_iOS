import UIKit

protocol DocumentsDelegate: class {
  func updated()
}

class DetailViewController: UIViewController {
  weak var delegate: DocumentsDelegate?
  var document: Document!
  
  init(document: Document) {
    self.document = document
    super.init(nibName: nil, bundle: nil)
    
    view = DetailView(image: document.image, name: document.name)
  }
  
  @objc func back() {
    let transition = CATransition()
    transition.duration = 0.1
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    transition.type = CATransitionType.fade
    self.navigationController?.view.layer.add(transition, forKey: nil)
    
    _ = navigationController?.popViewController(animated: false)
  }
  
  @objc func editName() {
    (view as? DetailView)?.nameField.isUserInteractionEnabled = true
    (view as? DetailView)?.nameField.becomeFirstResponder()
    
    let saveBtn = UIBarButtonItem(image: UIImage(named: "saveIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveDocument))
    self.navigationItem.rightBarButtonItem = saveBtn
  }
  
  @objc func saveDocument() {
    if let newName = (view as? DetailView)?.nameField.text {
      if newName != document.name {
        do {
          var directory = document.path
          directory.deleteLastPathComponent()
          
          let destinationPath = directory.appendingPathComponent(newName)
          try FileManager.default.moveItem(at: document.path, to: destinationPath)
          self.document = Document(name: newName, path: destinationPath, image: document.image)
          delegate?.updated()
          
          (view as? DetailView)?.nameField.isUserInteractionEnabled = false
        } catch {
          //TODO: handle error
        }
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

