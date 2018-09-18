import UIKit

protocol CreateFolderViewDelegate: class {
    func didEnter(folderName: String, codeHash: String?)
    func didClose()
}

class CreateFolderView: UIView {
    weak var delegate: CreateFolderViewDelegate?
    private lazy var infoService = InfoService()

    lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()

    lazy var newFolderView: UIView = {
        let newFolderView = UIView(frame: CGRect.zero)
        newFolderView.backgroundColor = Color.Dark.alertBackground
        newFolderView.layer.cornerRadius = 12.0
        newFolderView.translatesAutoresizingMaskIntoConstraints = false
        return newFolderView
    }()

    lazy var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect.zero)
        closeButton.layer.cornerRadius = 20.0
        closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        closeButton.setTitle("✖︎", for: .normal)
        closeButton.titleLabel?.font = Font.closeButton
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()

    lazy var infoTextView: InfoTextView = {
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

    lazy var folderCode: InputField = {
        let folderCode = InputField()
        folderCode.placeholder = "FolderCode"
        folderCode.isSecureTextEntry = true
        folderCode.translatesAutoresizingMaskIntoConstraints = false
        return folderCode
    }()

    lazy var doneButton: UIButton = {
        let doneButton = UIButton(frame: CGRect.zero)
        doneButton.layer.cornerRadius = 8.0
        doneButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        doneButton.setTitle("Create Folder", for: .normal)
        doneButton.titleLabel?.font = Font.textButton
        doneButton.addTarget(self, action: #selector(doneEntering), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()

    init() {
        super.init(frame: CGRect.zero)

        self.addSubview(backgroundView)
        self.addSubview(newFolderView)
        newFolderView.addSubview(closeButton)
        newFolderView.addSubview(infoTextView)
        newFolderView.addSubview(nameField)
        newFolderView.addSubview(folderCode)
        newFolderView.addSubview(doneButton)
        nameField.becomeFirstResponder()

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func closeView() {
        delegate?.didClose()
    }

    @objc func doneEntering() {
        if let folderName = nameField.text {
            if folderName.count > 0 {
                var passcodeHash: String?

                if folderCode.text?.count ?? 0 > 0 {
                    passcodeHash = folderCode.text?.sha256()
                }

                delegate?.didEnter(folderName: folderName, codeHash: passcodeHash)
            } else {
                infoService.showInfo(message: "no text entered", type: .warning)
            }
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            newFolderView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30.0),
            newFolderView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30.0),
            newFolderView.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 30.0),
            newFolderView.bottomAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 50.0),

            closeButton.topAnchor.constraint(equalTo: newFolderView.topAnchor, constant: 8.0),
            closeButton.trailingAnchor.constraint(equalTo: newFolderView.trailingAnchor, constant: -8.0),
            closeButton.widthAnchor.constraint(equalToConstant: 40.0),
            closeButton.heightAnchor.constraint(equalToConstant: 40.0),

            doneButton.bottomAnchor.constraint(equalTo: newFolderView.bottomAnchor, constant: -12.0),
            doneButton.centerXAnchor.constraint(equalTo: newFolderView.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 160.0),
            doneButton.heightAnchor.constraint(equalToConstant: 40.0),

            nameField.leadingAnchor.constraint(equalTo: newFolderView.leadingAnchor, constant: 16.0),
            nameField.trailingAnchor.constraint(equalTo: newFolderView.trailingAnchor, constant: -16.0),
            nameField.centerYAnchor.constraint(equalTo: newFolderView.centerYAnchor),
            nameField.centerXAnchor.constraint(equalTo: newFolderView.centerXAnchor),

            folderCode.leadingAnchor.constraint(equalTo: newFolderView.leadingAnchor, constant: 16.0),
            folderCode.trailingAnchor.constraint(equalTo: newFolderView.trailingAnchor, constant: -16.0),
            folderCode.topAnchor.constraint(equalTo:  nameField.bottomAnchor, constant: 16.0),
            folderCode.centerXAnchor.constraint(equalTo: newFolderView.centerXAnchor),

            infoTextView.leadingAnchor.constraint(equalTo: newFolderView.leadingAnchor, constant: 16.0),
            infoTextView.trailingAnchor.constraint(equalTo: newFolderView.trailingAnchor, constant: -16.0),
            infoTextView.bottomAnchor.constraint(equalTo: nameField.topAnchor, constant: -20.0),
            infoTextView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24.0),
            infoTextView.centerXAnchor.constraint(equalTo: newFolderView.centerXAnchor),
        ])
    }

}

