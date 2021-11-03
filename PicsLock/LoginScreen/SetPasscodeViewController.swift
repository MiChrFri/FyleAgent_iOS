import UIKit

final class SetPasscodeViewController: UIViewController {
    weak var delegate: LoginDelegate?
    
    lazy var descriptionField: UITextView = {
        let descriptionField = UITextView(frame: CGRect.zero)
        descriptionField.textColor = UIColor.white
        descriptionField.backgroundColor = .background
        descriptionField.isUserInteractionEnabled = false
        descriptionField.font = UIFont.systemFont(ofSize: 24.0)
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionField
    }()
    
    lazy var primaryPasscodeField: InputField = {
        let passcodeField = InputField()
        passcodeField.attributedPlaceholder = NSAttributedString(string: "Enter a Passcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        passcodeField.isSecureTextEntry = true
        passcodeField.keyboardType = .numberPad
        passcodeField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
        passcodeField.translatesAutoresizingMaskIntoConstraints = false
        
        return passcodeField
    }()
    
    lazy var secondaryPasscodeField: UITextField = {
        let passcodeField = InputField()
        passcodeField.attributedPlaceholder = NSAttributedString(string: "Repeat the Passcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        passcodeField.isSecureTextEntry = true
        passcodeField.keyboardType = .numberPad
        passcodeField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
        passcodeField.translatesAutoresizingMaskIntoConstraints = false
        
        return passcodeField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        
        view.addSubview(descriptionField)
        descriptionField.text = "Welcome to FyleAgent \n add a passcode to secure your files"
        
        view.addSubview(primaryPasscodeField)
        view.addSubview(secondaryPasscodeField)
        primaryPasscodeField.becomeFirstResponder()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            secondaryPasscodeField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            secondaryPasscodeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            secondaryPasscodeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            
            primaryPasscodeField.bottomAnchor.constraint(equalTo: secondaryPasscodeField.topAnchor, constant: -10.0),
            primaryPasscodeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            primaryPasscodeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            descriptionField.bottomAnchor.constraint(equalTo: primaryPasscodeField.topAnchor, constant: -50.0),
            descriptionField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
        ])
    }
    
    @objc private func didChange(textField: UITextField) {
        
        if primaryPasscodeField.text?.count ?? 0 >= 4 {
            if secondaryPasscodeField.text == primaryPasscodeField.text {
                UIView.animate(withDuration: 0.5, animations: {
                    self.descriptionField.text = "Welcome"
                }) { _ in
                    let passcodeHash = textField.text?.sha256() ?? ""
                    self.didSetPasscode(passcodeHash: passcodeHash)
                }
            }
        }
    }
    
    private func didSetPasscode(passcodeHash: String) {
        let defaults = UserDefaults.standard
        defaults.set(passcodeHash, forKey: "codeHash")
        
        delegate?.successfullyLoggedIn()
        self.dismiss(animated: true)
    }
    
    private enum Constants {
        static let padding: CGFloat = 24
    }
    
}
