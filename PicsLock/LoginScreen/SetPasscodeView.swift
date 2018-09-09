import UIKit

protocol SetPasscodeDelegate: class {
    func didSetPasscode(passcodeHash: String)
}

class SetPasscodeView: UIView {
    weak var delegate: SetPasscodeDelegate?

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = Color.Dark.background

        self.addSubview(descriptionField)
        descriptionField.text = "Welcome to APPNAME \n add a passcode to secure your files"

        self.addSubview(primaryPasscodeField)
        self.addSubview(secondaryPasscodeField)
        primaryPasscodeField.becomeFirstResponder()

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var descriptionField: UITextView = {
        let descriptionField = UITextView(frame: CGRect.zero)
        descriptionField.textColor = UIColor.white
        descriptionField.backgroundColor = Color.Dark.background
        descriptionField.isUserInteractionEnabled = false
        descriptionField.font = UIFont.systemFont(ofSize: 24.0)
        descriptionField.textAlignment = .center
        descriptionField.translatesAutoresizingMaskIntoConstraints = false

        return descriptionField
    }()

    lazy var primaryPasscodeField: InputField = {
        let passcodeField = InputField()
        passcodeField.attributedPlaceholder = NSAttributedString(string: "Enter a Passcode", attributes: [NSAttributedStringKey.foregroundColor: Color.Dark.placeholderText])
        passcodeField.isSecureTextEntry = true
        passcodeField.textAlignment = .center
        passcodeField.keyboardType = .numberPad
        passcodeField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
        passcodeField.translatesAutoresizingMaskIntoConstraints = false

        return passcodeField
    }()

    lazy var secondaryPasscodeField: UITextField = {
        let passcodeField = InputField()
        passcodeField.attributedPlaceholder = NSAttributedString(string: "Repeat the Passcode", attributes: [NSAttributedStringKey.foregroundColor: Color.Dark.placeholderText])
        passcodeField.isSecureTextEntry = true
        passcodeField.textAlignment = .center
        passcodeField.keyboardType = .numberPad
        passcodeField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
        passcodeField.translatesAutoresizingMaskIntoConstraints = false

        return passcodeField
    }()

    private func setupLayout() {
        NSLayoutConstraint.activate([
            secondaryPasscodeField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            secondaryPasscodeField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            secondaryPasscodeField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),

            primaryPasscodeField.bottomAnchor.constraint(equalTo: secondaryPasscodeField.topAnchor, constant: -10.0),
            primaryPasscodeField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            primaryPasscodeField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),

            descriptionField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            descriptionField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            descriptionField.bottomAnchor.constraint(equalTo: primaryPasscodeField.topAnchor, constant: -50.0),
            descriptionField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
        ])
    }

    @objc func didChange(textField: UITextField) {

        if primaryPasscodeField.text?.count ?? 0 >= 4 {
            if secondaryPasscodeField.text == primaryPasscodeField.text {
                UIView.animate(withDuration: 0.5, animations: {
                    self.descriptionField.text = "Awesome 😀😀"
                }) { (true) in
                    let passcodeHash = textField.text?.sha256() ?? ""
                    self.delegate?.didSetPasscode(passcodeHash: passcodeHash)
                }
            }
        }
    }
}
