import UIKit
import CryptoSwift
import Lottie

class NewLoginView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = Color.Dark.background
        self.addSubview(animationView)
        
        self.addSubview(passwordField)
        passwordField.becomeFirstResponder()
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var animationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "padlock_tick")
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

    lazy var passwordField: UITextField = {
        let passwordField = UITextField(frame: CGRect.zero)
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.tintColor = Color.Dark.navBarItems
        passwordField.textColor = UIColor.white
        passwordField.font = UIFont.systemFont(ofSize: 24.0)
        passwordField.textAlignment = .center
        passwordField.keyboardType = .numberPad
        
        return passwordField
    }()
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100.0),

            passwordField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            passwordField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            passwordField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
        ])
    }
    
}
