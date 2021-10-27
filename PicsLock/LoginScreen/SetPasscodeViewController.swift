import UIKit

final class SetPasscodeViewController: UIViewController {
    weak var delegate: LoginDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view = SetPasscodeView()
        (view as! SetPasscodeView).delegate = self
    }
}

extension SetPasscodeViewController: SetPasscodeDelegate {
    func didSetPasscode(passcodeHash: String) {
        let defaults = UserDefaults.standard
        defaults.set(passcodeHash, forKey: "codeHash")

        delegate?.successfullyLoggedIn()
        self.dismiss(animated: true)
    }
}
