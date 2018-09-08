import UIKit

protocol UnlockHiddenFolderViewDelegate: class {
    func didEnter(codeHash: String?)
    func didClose()
}

class UnlockHiddenFolderView: UIView {
    weak var delegate: UnlockHiddenFolderViewDelegate?

    lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()

    lazy var passcodeView: UIView = {
        let passcodeView = UIView(frame: CGRect.zero)
        passcodeView.backgroundColor = UIColor.gray
        passcodeView.layer.cornerRadius = 12.0
        passcodeView.translatesAutoresizingMaskIntoConstraints = false
        return passcodeView
    }()

    lazy var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect.zero)
        closeButton.layer.cornerRadius = 20.0
        closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        closeButton.setTitle("×", for: .normal)
        closeButton.titleLabel?.font = Font.closeButton
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()

    lazy var doneButton: UIButton = {
        let doneButton = UIButton(frame: CGRect.zero)
        doneButton.layer.cornerRadius = 4.0
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = Font.inputField
        doneButton.addTarget(self, action: #selector(doneEntering), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()

    lazy var folderCode: InputField = {
        let folderCode = InputField()
        folderCode.placeholder = "FolderCode"
        folderCode.isSecureTextEntry = true
        folderCode.translatesAutoresizingMaskIntoConstraints = false
        return folderCode
    }()

    init() {
        super.init(frame: CGRect.zero)

        self.addSubview(backgroundView)
        self.addSubview(passcodeView)
        passcodeView.addSubview(closeButton)
        passcodeView.addSubview(doneButton)
        passcodeView.addSubview(folderCode)
        folderCode.becomeFirstResponder()

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func closeView() {
        delegate?.didClose()
    }

    @objc func doneEntering() {
        if let folderCode = folderCode.text {
            if folderCode.count > 0 {
                let passcodeHash = folderCode.sha256()
                delegate?.didEnter(codeHash: passcodeHash)
            } else {
                print("no text entered")
                // TODO: Error message for user
            }
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            passcodeView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30.0),
            passcodeView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30.0),
            passcodeView.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 30.0),
            passcodeView.bottomAnchor.constraint(equalTo: backgroundView.centerYAnchor),

            closeButton.topAnchor.constraint(equalTo: passcodeView.topAnchor, constant: 4.0),
            closeButton.trailingAnchor.constraint(equalTo: passcodeView.trailingAnchor, constant: -4.0),
            closeButton.widthAnchor.constraint(equalToConstant: 40.0),
            closeButton.heightAnchor.constraint(equalToConstant: 40.0),

            doneButton.bottomAnchor.constraint(equalTo: passcodeView.bottomAnchor, constant: 4.0),
            doneButton.trailingAnchor.constraint(equalTo: passcodeView.trailingAnchor, constant: -4.0),
            doneButton.widthAnchor.constraint(equalToConstant: 80.0),
            doneButton.heightAnchor.constraint(equalToConstant: 40.0),

            folderCode.leadingAnchor.constraint(equalTo: passcodeView.leadingAnchor, constant: 16.0),
            folderCode.trailingAnchor.constraint(equalTo: passcodeView.trailingAnchor, constant: -16.0),
            folderCode.topAnchor.constraint(equalTo:  passcodeView.bottomAnchor, constant: 16.0),
            folderCode.centerXAnchor.constraint(equalTo: passcodeView.centerXAnchor),
        ])
    }

}

