import UIKit
import CryptoSwift
import NotificationBannerSwift

class LoginViewController: UIViewController {
    weak var delegate: LoginDelegate?
    private let passcodeHash: String!
    private lazy var infoService = InfoService()

    init() {
        self.passcodeHash = UserDefaults.standard.object(forKey: "codeHash") as? String ?? ""
        super.init(nibName: nil, bundle: nil)

        if passcodeHash.isEmpty {
            view = SetPasscodeView()
            (view as! SetPasscodeView).delegate = self
        } else {
            view = LoginView()
            (view as! LoginView).passwordField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didChange(textField: UITextField) {
        if textField.text?.count == 4 {
            if textField.text?.sha256() ?? "" == passcodeHash {
                infoService.showInfo(message: "successfully logged in", type: .success)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.delegate?.successfullyLoggedIn()
                    self.dismiss(animated: true)
                }
            } else {
                infoService.showInfo(message: "wrong passcode", type: .danger)
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
