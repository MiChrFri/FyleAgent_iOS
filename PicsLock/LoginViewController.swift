import UIKit
import CryptoSwift

class LoginViewController: UIViewController {
    weak var delegate: LoginDelegate?
    private let passcodeHash: String!

    init() {
        self.passcodeHash = UserDefaults.standard.object(forKey: "codeHash") as? String ?? ""
        super.init(nibName: nil, bundle: nil)

        if passcodeHash.isEmpty {
            view = SetPasscodeView()
            (view as! SetPasscodeView).delegate = self
        } else {

        }
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

    lazy var passwordField: UITextField = {
        let passwordField = UITextField(frame: CGRect.zero)
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = Color.Dark.textBackground
        passwordField.textColor = UIColor.white
        passwordField.font = UIFont.systemFont(ofSize: 24.0)
        passwordField.textAlignment = .center
        passwordField.keyboardType = .numberPad
        passwordField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)

        return passwordField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


        if passcodeHash.count > 0 {

            view.backgroundColor = Color.Dark.background

            view.addSubview(descriptionField)
            descriptionField.text = "Welcome pal \n enter your password"

            view.addSubview(passwordField)
            passwordField.becomeFirstResponder()

            setupLayout()
        }


    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),

            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            descriptionField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -50.0),
            descriptionField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
        ])
    }

    @objc func didChange(textField: UITextField) {
        if textField.text?.count == 4 {
            if textField.text?.sha256() ?? "" == passcodeHash {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.descriptionField.text = "😀😀"
                }) { (true) in

                    self.delegate?.successfullyLoggedIn()
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

extension LoginViewController: LoginDelegate {
    func successfullyLoggedIn() {
        delegate?.successfullyLoggedIn()
    }
}

extension LoginViewController: SetPasscodeDelegate {
    func didSetPasscode(passcodeHash: String) {
        let defaults = UserDefaults.standard
        defaults.set(passcodeHash, forKey: "codeHash")

        delegate?.successfullyLoggedIn()
        self.dismiss(animated: true)
    }
}