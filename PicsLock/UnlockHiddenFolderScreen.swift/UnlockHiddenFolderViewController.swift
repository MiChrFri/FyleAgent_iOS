import UIKit

protocol UnlockHiddenFolderDelegate: AnyObject {
    func didEnter(folderCodeHash: String)
}

class UnlockHiddenFolderViewController: UIViewController {
    weak var delegate: UnlockHiddenFolderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view = UnlockHiddenFolderView()
        (view as? UnlockHiddenFolderView)?.delegate = self
    }
}

extension UnlockHiddenFolderViewController: UnlockHiddenFolderViewDelegate {
    func didClose() {
        self.dismiss(animated: true)
    }

    func didEnter(codeHash: String?) {
        if let codeHash = codeHash {
            delegate?.didEnter(folderCodeHash: codeHash)
        }

        self.dismiss(animated: true)
    }
}
