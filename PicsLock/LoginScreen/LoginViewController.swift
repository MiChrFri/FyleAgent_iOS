import UIKit
import Lottie

protocol LoginDelegate: AnyObject {
    func successfullyLoggedIn()
}

final class LoginViewController: UIViewController {
    weak var delegate: LoginDelegate?
    private let passcodeHash: String
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "padlock_tick")
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
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
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100.0),
            
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
        view.addSubview(animationView)
        
        view.addSubview(passwordField)
        passwordField.becomeFirstResponder()
        
        setupLayout()
    }
    
    @objc func didChange(textField: UITextField) {
        if textField.text?.count ?? 0 >= 4 {
            if textField.text?.sha256() ?? "" == passcodeHash {
                textField.isUserInteractionEnabled = false
                
                animationView.play(
                    toFrame: 60,
                    completion: { (finished) in
                        self.delegate?.successfullyLoggedIn()
                        self.dismiss(animated: true)
                    })
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
