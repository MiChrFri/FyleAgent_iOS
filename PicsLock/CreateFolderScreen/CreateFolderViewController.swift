import UIKit

protocol CreateFolderDelegate: class {
    func didCreate()
}

class CreateFolderViewController: UIViewController {
    weak var delegate: CreateFolderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view = CreateFolderView()
        (view as? CreateFolderView)?.delegate = self
    }
}

extension CreateFolderViewController: CreateFolderViewDelegate {
    func didClose() {
        self.dismiss(animated: true)
    }

    func didEnter(folderName: String, codeHash: String?) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = documentsDirectory.appendingPathComponent(folderName)

        do {
            try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            if let accesscodeHash = codeHash{
                let defaults = UserDefaults.standard
                defaults.set(accesscodeHash, forKey: folderName)
            }
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }

        delegate?.didCreate()
        self.dismiss(animated: true)
    }
}