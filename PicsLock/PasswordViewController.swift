import UIKit
import CryptoSwift


class PasswordViewController: UIViewController {

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

        view.backgroundColor = Color.Dark.background
        view.addSubview(passwordField)
        passwordField.becomeFirstResponder()
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            passwordField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24.0),
            passwordField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24.0),
            passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func didChange(textField: UITextField) {
        if textField.text?.count == 4 {
            if textField.text?.sha256() ?? "" == "9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0" {
                let albumsViewController = AlbumsViewController()
                self.navigationController?.pushViewController(albumsViewController, animated: true)
            }
        }
    }
}
