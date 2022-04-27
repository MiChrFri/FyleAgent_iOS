import UIKit

protocol LoginDelegate: AnyObject {
    func successfullyLoggedIn()
}

final class LoginViewController: UIViewController {
    weak var delegate: LoginDelegate?
    private let passcodeHash: String
    
    private lazy var passwordField: UITextField = {
        let passwordField = UITextField(frame: CGRect.zero)
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.tintColor = .navBarItems
        passwordField.textColor = UIColor.white
        passwordField.font = UIFont.systemFont(ofSize: 24.0)
        passwordField.textAlignment = .center
        passwordField.keyboardType = .numberPad
        
        return passwordField
    }()
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
        ])
    }
    
    init() {
        passcodeHash = UserDefaults.standard.object(forKey: "codeHash") as? String ?? ""
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
        
        passwordField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        
        view.addSubview(passwordField)
        passwordField.becomeFirstResponder()
        
        setupLayout()
    }
    
    @objc func didChange(textField: UITextField) {
        if textField.text?.count ?? 0 >= 4 {
            if textField.text?.sha256() ?? "" == passcodeHash {
                textField.isUserInteractionEnabled = false

                self.delegate?.successfullyLoggedIn()
                self.dismiss(animated: true)
            } else {
                textField.text = ""
                redFlash()
            }
        }
    }
    
    private func redFlash() {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.backgroundColor = .errorBackground
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = .background
            })
        }
    }
}

extension LoginViewController: LoginDelegate {
    func successfullyLoggedIn() {
        delegate?.successfullyLoggedIn()
    }
}
