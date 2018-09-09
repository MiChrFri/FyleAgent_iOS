import UIKit

protocol DocumentsDelegate: class {
    func updated()
}

class DetailViewController: UIViewController {
    weak var delegate: DocumentsDelegate?
    private lazy var infoService = InfoService(viewController: self)
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

    @objc func saveName() {
        if let newName = (view as? DetailView)?.nameField.text {
            if newName != document.name {
                do {
                    var directory = document.path
                    directory.deleteLastPathComponent()

                    let destinationPath = directory.appendingPathComponent(newName)
                    try FileManager.default.moveItem(at: document.path, to: destinationPath)
                    self.document = Document(name: newName, path: destinationPath, image: document.image)
                    delegate?.updated()
                } catch {
                    infoService.showInfo(message: "\(error)", type: .error)
                }
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

        let saveName = UIBarButtonItem(title: "Save name", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.saveName))
        self.navigationItem.rightBarButtonItem = saveName
    }

}

