import UIKit

class FilesViewController: UIViewController {
  var  currentIndex = 0
  
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
    
    layout.scrollDirection = UICollectionViewScrollDirection.vertical
    collectionView.setCollectionViewLayout(layout, animated: true)
    collectionView.backgroundColor = Color.Dark.background
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
    
    let newBackButton = UIBarButtonItem(image: UIImage(named: "newDocIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addImage(sender:)))
    self.navigationItem.rightBarButtonItem = newBackButton
  }
  
  @objc func addImage(sender: UIBarButtonItem) {
    let imagePickerAlert = UIAlertController(title: "Select an Image", message: nil, preferredStyle: .alert)
    
    imagePickerAlert.view.tintColor = UIColor.systemPink
    imagePickerAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    imagePickerAlert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) in
      self.permissionsManager.handleCameraPermission()
    }))
    imagePickerAlert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (action) in
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
  
  private func presentImagePicker(withType type: UIImagePickerControllerSourceType) {
    if let imagePicker = self.imageProvider.pickerController(from: type ) {
      imagePicker.delegate = self
      self.present(imagePicker, animated: false)
    }
  }
  
  private func reloadData() {
    files = fileService.files(at: folderPath)
    collectionView.reloadData()
  }
  
  func pickedImage(image: UIImage?) {
    if let img = image {
      guard let data = UIImageJPEGRepresentation(img, 0.5) ?? UIImagePNGRepresentation(img) else {return}
      
      do {
        let tmp_name = "\(Int(Date().timeIntervalSince1970)).png"
        let imagePath = folderPath.appendingPathComponent(tmp_name)
        try data.write(to: imagePath)
        
      } catch {
        print(error.localizedDescription)
      }
      
      reloadData()
    }
  }
}

extension FilesViewController: DocumentsDelegate {
  func updated() {
    reloadData()
  }
}

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {dismiss(animated:false, completion:nil); return }
    
    dismiss(animated:false, completion: { () in
      self.pickedImage(image: pickedImage)
    })
  }
}

extension FilesViewController: PermissionManagerDelegate {
  func allowed(for sourceType: UIImagePickerControllerSourceType) {
    self.presentImagePicker(withType: sourceType)
  }
  
  func denied(for permissionType: UIImagePickerControllerSourceType) {
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
    errorAlert.view.tintColor = Color.Dark.lightText
    errorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    errorAlert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (action) in
      let app = UIApplication.shared
      let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
      
      app.open(settingsUrl!, options: [:], completionHandler: nil)
    }))
    
    self.present(errorAlert, animated: true, completion: nil)
  }
}
