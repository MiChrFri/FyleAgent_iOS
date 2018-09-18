import UIKit
import CryptoSwift
import NotificationBannerSwift

class LoginView: UIView {

    init() {
        super.init(frame: CGRect.zero)

        self.backgroundColor = Color.Dark.background

        self.addSubview(descriptionField)
        descriptionField.text = "Welcome pal \n enter your password"

        self.addSubview(passwordField)
        passwordField.becomeFirstResponder()

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

    lazy var passwordField: UITextField = {
        let passwordField = UITextField(frame: CGRect.zero)
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = Color.Dark.textBackground
        passwordField.textColor = UIColor.white
        passwordField.font = UIFont.systemFont(ofSize: 24.0)
        passwordField.textAlignment = .center
        passwordField.keyboardType = .numberPad

        return passwordField
    }()

    private func setupLayout() {
        NSLayoutConstraint.activate([
            passwordField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            passwordField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            passwordField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),

            descriptionField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            descriptionField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            descriptionField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -50.0),
            descriptionField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
        ])
    }

}
