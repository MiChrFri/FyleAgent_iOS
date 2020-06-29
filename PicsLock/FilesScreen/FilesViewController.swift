import UIKit

class FilesViewController: UIViewController {
  var currentIndex = 0
  var currentPage = 0
  var detailViewController: UIPageViewController?
  
  private(set) lazy var orderedViewControllers: [UIViewController] = {
    var vcs = [UIViewController]()
    
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
  let fileService = FileService()
  var files = [File]()
  let folderPath: URL
  
  let collectionView: UICollectionView = {
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
  
  @objc func addImage(sender: UIBarButtonItem) {
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
    
    var vcs = [UIViewController]()

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
  
  func pickedImage(image: UIImage?) {
    if let img = image {
      guard let data = img.jpegData(compressionQuality: 0.5) ?? img.pngData() else {return}
      
      let tmp_name = "\(UUID()).png"
      let imagePath = folderPath.appendingPathComponent(tmp_name)
      try? data.write(to: imagePath)
      
      reloadData()
    }
  }
  
  @objc func editName() {
    (orderedViewControllers[currentPage].view as? DetailView)?.nameField.isUserInteractionEnabled = true
    (orderedViewControllers[currentPage].view as? DetailView)?.nameField.becomeFirstResponder()
    
    let saveBtn = UIBarButtonItem(image: UIImage(named: "saveIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveDocument))
    self.detailViewController?.navigationItem.rightBarButtonItem = saveBtn
  }
  
  @objc func saveDocument() {
    let deatilVC = (orderedViewControllers[currentPage] as? DetailViewController)
    
    guard var document = deatilVC?.document else { return }
    
    if let newName = (deatilVC?.view as? DetailView)?.nameField.text {
      let documentsMananger = DocumentsManager()
      if let savedDocument = documentsMananger.saveDocument(document, forName: newName) {
        document = savedDocument
        
        reloadData()
        (view as? DetailView)?.nameField.isUserInteractionEnabled = false
        setupNavigationItems()
      }
    }
  }
  
  @objc func deleteDocument() {
    let deatilVC = (orderedViewControllers[currentPage] as? DetailViewController)
    guard let document = deatilVC?.document else { return }

    self.back()
    try? FileManager.default.removeItem(at: document.path)
    reloadData()
  }
  
  @objc func back() {
    let transition = CATransition()
    transition.duration = 0.1
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    transition.type = CATransitionType.fade
    self.navigationController?.view.layer.add(transition, forKey: nil)
    
    _ = navigationController?.popViewController(animated: false)
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
