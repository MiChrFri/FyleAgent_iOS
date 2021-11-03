import UIKit

protocol DocumentsDelegate: AnyObject {
    func updated()
}

class DetailViewController: UIViewController {
    weak var delegate: DocumentsDelegate?
    var document: Document
    
    private lazy var zoomView: ZoomView = {
        let zoomView = ZoomView()
        zoomView.translatesAutoresizingMaskIntoConstraints = false
        return zoomView
    }()
    
    var nameField: NameField = {
        let nameField = NameField()
        nameField.placeholder = "Foldername"
        nameField.isUserInteractionEnabled = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()
    
    init(document: Document) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    @objc func back() {
        let transition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
    private func setupView() {
        view.addSubview(zoomView)
        view.addSubview(nameField)
        nameField.text = document.name
        zoomView.image = document.image
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            zoomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zoomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zoomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            zoomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 40.0),
        ])
    }
    
    @objc func editName() {
        nameField.isUserInteractionEnabled = true
        nameField.becomeFirstResponder()
        
        let saveBtn = UIBarButtonItem(image: UIImage(named: "saveIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveDocument))
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    @objc func saveDocument() {
        if let newName = nameField.text {
            if newName != document.name {
                do {
                    var directory = document.path
                    directory.deleteLastPathComponent()
                    
                    let destinationPath = directory.appendingPathComponent(newName)
                    try FileManager.default.moveItem(at: document.path, to: destinationPath)
                    self.document = Document(name: newName, path: destinationPath, image: document.image)
                    delegate?.updated()
                    
                    nameField.isUserInteractionEnabled = false
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

