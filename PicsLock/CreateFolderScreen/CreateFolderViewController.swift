import UIKit

protocol CreateFolderDelegate: AnyObject {
    func didCreate()
}

final class CreateFolderViewController: UIViewController {
    private let fileService = FileService()
    weak var delegate: CreateFolderDelegate?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            iconView,
            infoTextView,
            nameField,
            folderCode
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.alertBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 12
        backgroundView.clipsToBounds = true
        return backgroundView
    }()

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var infoTextView: InfoTextView = {
        let infoTextView = InfoTextView()
        infoTextView.text = "Set the name for your folder and if you want a password for it"
        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        return infoTextView
    }()
    
    lazy var nameField: InputField = {
        let nameField = InputField()
        nameField.placeholder = "Foldername"
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()
    
    private lazy var folderCode: InputField = {
        let folderCode = InputField()
        folderCode.placeholder = "FolderCode"
        folderCode.isSecureTextEntry = true
        folderCode.translatesAutoresizingMaskIntoConstraints = false
        return folderCode
    }()
    
    private lazy var doneButton: UIButton = {
        let button = Button()
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.setTitle("create folder", for: .normal)
        button.addTarget(self, action: #selector(doneEntering), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        view.addSubview(doneButton)
        nameField.becomeFirstResponder()
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    @objc func doneEntering() {
        if let folderName = nameField.text {
            if folderName.count > 0 {
                var passcodeHash: String?
                
                if let code = folderCode.text, !code.isEmpty {
                    passcodeHash = code.sha256()
                }
                
                didEnter(folderName: folderName, codeHash: passcodeHash)
            }
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -doneButton.frame.height),

            iconView.heightAnchor.constraint(equalToConstant: 100),

            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -28),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didEnter(folderName: String, codeHash: String?) {
        fileService.createFolder(folderName: folderName, codeHash: codeHash)
        delegate?.didCreate()
        closeView()
    }
}
