import UIKit

protocol DocumentsDelegate: class {
    func updated()
}

class DetailViewController: UIViewController {
    weak var delegate: DocumentsDelegate?
    private let fileManager = FileManager.default
    var document: Document!
    
    init(document: Document) {
        self.document = document
        super.init(nibName: nil, bundle: nil)

        view = DetailView(image: document.image, name: document.name)
        setupNavigationItems()
    }

    @objc func back() {
        let transition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)

        _ = navigationController?.popViewController(animated: false)
    }

    @objc func editName() {
        (view as? DetailView)?.nameField.isUserInteractionEnabled = true
        (view as? DetailView)?.nameField.becomeFirstResponder()
        
        let saveBtn = UIBarButtonItem(image: UIImage(named: "saveIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.saveDocument))
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    @objc func saveDocument() {
        if let newName = (view as? DetailView)?.nameField.text {
            if newName != document.name {
                do {
                    var directory = document.path
                    directory.deleteLastPathComponent()

                    let destinationPath = directory.appendingPathComponent(newName)
                    try fileManager.moveItem(at: document.path, to: destinationPath)
                    self.document = Document(name: newName, path: destinationPath, image: document.image)
                    delegate?.updated()
                    
                    (view as? DetailView)?.nameField.isUserInteractionEnabled = false
                    setupNavigationItems()
                } catch {
                    //TODO: handle error
                }
            }
        }
    }
    
    @objc func deleteDocument() {
        UIView.animate(withDuration: 0, animations: {
            self.back()
        }) { (true) in
            do {
                try self.fileManager.removeItem(at: self.document.path)
                self.delegate?.updated()
            } catch {
                //TODO: handle error
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationItems() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = newBackButton

        let editName = UIBarButtonItem(image: UIImage(named: "editIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editName))
        
        let delete = UIBarButtonItem(image: UIImage(named: "deleteIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.deleteDocument))
        
        self.navigationItem.rightBarButtonItems = [editName, delete]
    }

}

