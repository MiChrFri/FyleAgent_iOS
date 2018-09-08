import UIKit

protocol CreateFolderViewDelegate: class {
    func didEnter(folderName: String)
    func didClose()
}

class CreateFolderView: UIView {
    weak var delegate: CreateFolderViewDelegate?

    lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()

    lazy var newFolderView: UIView = {
        let newFolderView = UIView(frame: CGRect.zero)
        newFolderView.backgroundColor = UIColor.gray
        newFolderView.layer.cornerRadius = 12.0
        newFolderView.translatesAutoresizingMaskIntoConstraints = false
        return newFolderView
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

    lazy var nameField: InputField = {
        let nameField = InputField()
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()

    @objc func closeView() {
        delegate?.didClose()
    }

    @objc func doneEntering() {
        if let folderName = nameField.text {
            if folderName.count > 0 {
                delegate?.didEnter(folderName: folderName)
            } else {
                print("no text entered")
                // TODO: Error message for user
            }
        }
    }

    init() {
        super.init(frame: CGRect.zero)

        self.addSubview(backgroundView)
        self.addSubview(newFolderView)
        newFolderView.addSubview(closeButton)
        newFolderView.addSubview(doneButton)
        newFolderView.addSubview(nameField)
        nameField.becomeFirstResponder()

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            newFolderView.bottomAnchor.constraint(equalTo: backgroundView.centerYAnchor),

            closeButton.topAnchor.constraint(equalTo: newFolderView.topAnchor, constant: 4.0),
            closeButton.trailingAnchor.constraint(equalTo: newFolderView.trailingAnchor, constant: -4.0),
            closeButton.widthAnchor.constraint(equalToConstant: 40.0),
            closeButton.heightAnchor.constraint(equalToConstant: 40.0),

            doneButton.bottomAnchor.constraint(equalTo: newFolderView.bottomAnchor, constant: 4.0),
            doneButton.trailingAnchor.constraint(equalTo: newFolderView.trailingAnchor, constant: -4.0),
            doneButton.widthAnchor.constraint(equalToConstant: 80.0),
            doneButton.heightAnchor.constraint(equalToConstant: 40.0),

            nameField.leadingAnchor.constraint(equalTo: newFolderView.leadingAnchor, constant: 16.0),
            nameField.trailingAnchor.constraint(equalTo: newFolderView.trailingAnchor, constant: -16.0),
            nameField.centerYAnchor.constraint(equalTo: newFolderView.centerYAnchor),
            nameField.centerXAnchor.constraint(equalTo: newFolderView.centerXAnchor),
        ])
    }

}

