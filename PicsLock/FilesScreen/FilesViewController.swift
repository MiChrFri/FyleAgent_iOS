import UIKit

class FilesViewController: UIViewController {
    private var currentIndex = 0
    private var currentPage = 0
    private var detailViewController: UIPageViewController?
    
    private(set) lazy var orderedViewControllers: [DetailViewController] = {
        var vcs = [DetailViewController]()
        
        for file in files {
            if let img = UIImage(contentsOfFile: file.path.relativePath) {
                let doc = Document(name: file.path.lastPathComponent, path: file.path, image: img)
                let vc = DetailViewController(document: doc)
                vcs.append(vc)
            }
        }
        
        return vcs
    }()
    
    private let permissionsManager = PermissionManager()
    private let imageProvider = ImageProvider()
    private let fileService = FileService()
    
    private var files = [File]()
    private let folderPath: URL
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(FilesCollectionViewCell.self, forCellWithReuseIdentifier: "files_cell_Id")
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.backgroundColor = .background
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        return collectionView
    }()
    
    init(folderPath: URL) {
        self.folderPath = folderPath
        super.init(nibName: nil, bundle: nil)
        
        permissionsManager.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        files = fileService.files(at: folderPath)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupNavigationItems()
        setupLayout()
    }
    
    private func setupNavigationItems() {
        title = folderPath.lastPathComponent
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "newDocIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.addImage(sender:)))
        self.navigationItem.rightBarButtonItem = newBackButton
    }
    
    @objc private func addImage(sender: UIBarButtonItem) {
        let imagePickerAlert = UIAlertController(title: "Select an Image", message: nil, preferredStyle: .alert)
        
        imagePickerAlert.view.tintColor = UIColor.systemPink
        imagePickerAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        imagePickerAlert.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (action) in
            self.permissionsManager.handleCameraPermission()
        }))
        imagePickerAlert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default, handler: { (action) in
            self.permissionsManager.handlePhotoLibraryPermission()
        }))
        
        self.present(imagePickerAlert, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func presentImagePicker(withType type: UIImagePickerController.SourceType) {
        if let imagePicker = self.imageProvider.pickerController(from: type ) {
            imagePicker.delegate = self
            self.present(imagePicker, animated: false)
        }
    }
    
    private func reloadData() {
        files = fileService.files(at: folderPath)
        
        var vcs = [DetailViewController]()
        
        for file in files {
            if let img = UIImage(contentsOfFile: file.path.relativePath) {
                let doc = Document(name: file.path.lastPathComponent, path: file.path, image: img)
                let vc = DetailViewController(document: doc)
                vcs.append(vc)
            }
        }
        
        orderedViewControllers = vcs
        collectionView.reloadData()
    }
    
    private func pickedImage(image: UIImage?) {
        if let img = image {
            guard let data = img.jpegData(compressionQuality: 0.5) ?? img.pngData() else {return}
            
            let tmp_name = "\(UUID()).png"
            let imagePath = folderPath.appendingPathComponent(tmp_name)
            try? data.write(to: imagePath)
            
            reloadData()
        }
    }
    
    @objc private func editName() {
        orderedViewControllers[currentPage].nameField.isUserInteractionEnabled = true
        orderedViewControllers[currentPage].nameField.becomeFirstResponder()
        
        let saveBtn = UIBarButtonItem(image: UIImage(named: "saveIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveDocument))
        
        if orderedViewControllers.count == 1 {
            orderedViewControllers[0].navigationItem.rightBarButtonItem = saveBtn
        } else {
            detailViewController?.navigationItem.rightBarButtonItem = saveBtn
        }
    }
    
    @objc private func saveDocument() {
        let deatilVC = orderedViewControllers[currentPage]
        var document = deatilVC.document
        
        if let newName = deatilVC.nameField.text {
            let documentsMananger = DocumentsManager()
            if let savedDocument = documentsMananger.saveDocument(document, forName: newName) {
                document = savedDocument
                
                reloadData()
                deatilVC.nameField.isUserInteractionEnabled = false
                deatilVC.nameField.resignFirstResponder()
                
                setupNavigationItems()
            }
        }
    }
    
    @objc private func deleteDocument() {
        let document = orderedViewControllers[currentPage].document
        
        back()
        try? FileManager.default.removeItem(at: document.path)
        reloadData()
    }
    
    @objc private func back() {
        let transition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
}

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let pickedImage = info[UIImagePickerController.InfoKey(rawValue: convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage))] as? UIImage else {dismiss(animated:false, completion:nil); return }
            
            dismiss(animated:false, completion: { () in
                self.pickedImage(image: pickedImage)
            })
        }
}

extension FilesViewController: PermissionManagerDelegate {
    func allowed(for sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.presentImagePicker(withType: sourceType)
        }
    }
    
    func denied(for permissionType: UIImagePickerController.SourceType) {
        var alertTitle: String
        var alertMessage: String
        
        switch permissionType {
        case .camera:
            alertTitle = "Photos"
            alertMessage = "Allow APPNAME to access your camera if you want to take photos. You can change the permissions in your settings and try again"
        case .photoLibrary, .savedPhotosAlbum:
            alertTitle = "Photo Library"
            alertMessage = "Allow APPNAME to access your photo library if you want load and store photos from it. You can change the permissions in your settings and try again"
        @unknown default:
            alertTitle = "-"
            alertMessage = "-"
        }
        
        let errorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        errorAlert.view.tintColor = .lightText
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        errorAlert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (action) in
            let app = UIApplication.shared
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            
            app.open(settingsUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }))
        
        self.present(errorAlert, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}


extension FilesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "files_cell_Id", for: indexPath) as! FilesCollectionViewCell
        
        if let img = UIImage(contentsOfFile: files[indexPath.row].path.relativePath) {
            cell.composeView(withImage: img)
            cell.name = files[indexPath.row].name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        currentIndex = index
        currentPage = index
        
        let transition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        let detailViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        detailViewController.setViewControllers([orderedViewControllers[index]], direction: .forward, animated: true, completion: nil)
        detailViewController.dataSource = self
        
        self.detailViewController = detailViewController
        
        if orderedViewControllers.count == 1 {
            self.navigationController?.pushViewController(orderedViewControllers[index], animated: false)
            setupNavigationItems(for: orderedViewControllers[index])
            return
        } else {
            self.navigationController?.pushViewController(detailViewController, animated: false)
            setupNavigationItems(for: detailViewController)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = UIScreen.main.bounds.width / 3 - 16
            
            return CGSize(width: width, height: width+30)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5.0
        }
}

// MARK: UIPageViewControllerDataSource
extension FilesViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let orderedViewController = viewController as? DetailViewController else { return nil }
        
        if let index = orderedViewControllers.firstIndex(of: orderedViewController) {
            setupNavigationItems(for: detailViewController)
            currentPage = index
            
            if index > 0 {
                let index = index - 1
                currentIndex = index
                return orderedViewControllers[index]
            } else {
                let index = orderedViewControllers.count - 1
                currentIndex = index
                return orderedViewControllers[index]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let orderedViewController = viewController as? DetailViewController else { return nil }
        
        if let index = orderedViewControllers.firstIndex(of: orderedViewController) {
            setupNavigationItems(for: detailViewController)
            currentPage = index
            if index < orderedViewControllers.count - 1 {
                let index = index + 1
                currentIndex = index
                return orderedViewControllers[index]
            } else {
                let index = 0
                currentIndex = index
                return orderedViewControllers[index]
            }
        }
        
        return nil
    }
    
    private func setupNavigationItems(for viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        viewController.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(back))
        viewController.navigationItem.leftBarButtonItem = newBackButton
        
        let editName = UIBarButtonItem(image: UIImage(named: "editIcon"), style: .plain, target: self, action: #selector(editName))
        let delete = UIBarButtonItem(image: UIImage(named: "deleteIcon"), style: .plain, target: self, action: #selector(deleteDocument))
        
        viewController.navigationItem.rightBarButtonItems = [editName, delete]
    }
    
}
