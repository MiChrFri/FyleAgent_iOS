import UIKit

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
             view = NewLoginView()
            (view as! NewLoginView).passwordField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didChange(textField: UITextField) {
        if textField.text?.count ?? 0 >= 4 {
            if textField.text?.sha256() ?? "" == passcodeHash {
                textField.isUserInteractionEnabled = false
                
                if let loginview = view as? NewLoginView {
                  loginview.animationView.play(toFrame: 60, completion: { (finished) in
                                                self.delegate?.successfullyLoggedIn()
                                                self.dismiss(animated: true)
                    })
                }
            } else {
                textField.text = ""
                self.redFlash()
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

extension LoginViewController: SetPasscodeDelegate {
    func didSetPasscode(passcodeHash: String) {
        let defaults = UserDefaults.standard
        defaults.set(passcodeHash, forKey: "codeHash")

        delegate?.successfullyLoggedIn()
        self.dismiss(animated: true)
    }
}
