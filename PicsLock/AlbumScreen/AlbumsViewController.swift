import UIKit

class AlbumsViewController: UIViewController {
  let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
  private var hiddenFolders: Set<Folder> = []
  private var visibleFolders: Set<Folder> = []
  private var visibleFoldersSorted = [Folder]()
  private var loggedIn = false
  private lazy var fileService = FileService()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if !loggedIn {
      login()
    }
  }
  
  private func login() {
    let loginViewController = LoginViewController()
    loginViewController.delegate = self
    loginViewController.modalPresentationStyle = .fullScreen
    navigationController?.present(loginViewController, animated:true, completion: nil)
  }
  
  func addCollectionView() {
    setNeedsStatusBarAppearanceUpdate()
    
    collectionView.register(AlbumsCollectionViewCell.self, forCellWithReuseIdentifier: "cell_Id")
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    layout.scrollDirection = UICollectionView.ScrollDirection.vertical
    collectionView.setCollectionViewLayout(layout, animated: true)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .background
    
    collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    view.addSubview(collectionView)
    
    setupNavigationItems()
    setupLayout()
  }
  
  @objc func newFolder() {
    let createFolderViewController = CreateFolderViewController()
    createFolderViewController.modalPresentationStyle = .overCurrentContext
    createFolderViewController.delegate = self
    present(createFolderViewController, animated:true, completion: nil)
  }
  
  @objc func unlock() {
    let unlockHiddenFolderViewController = UnlockHiddenFolderViewController()
    unlockHiddenFolderViewController.modalPresentationStyle = .overCurrentContext
    unlockHiddenFolderViewController.delegate = self
    present(unlockHiddenFolderViewController, animated:true, completion: nil)
  }
  
  private func setupNavigationItems() {
    navigationItem.hidesBackButton = true
    
    let unlockButton = UIBarButtonItem(image: UIImage(named: "lockIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(unlock))
    navigationItem.leftBarButtonItem = unlockButton
    
    let newFolderButton = UIBarButtonItem(image: UIImage(named: "newFolderIcon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(newFolder))
    navigationItem.rightBarButtonItem = newFolderButton
  }
  
  private func setupLayout() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
}

extension AlbumsViewController: LoginDelegate {
  func successfullyLoggedIn() {
    loggedIn = true
    let folders = fileService.folders()
    
    for folder in folders {
      if let accesscodeHash = UserDefaults.standard.object(forKey: folder.name) as? String {
        var f = folder
        f.accesscodeHash = accesscodeHash
        hiddenFolders.insert(f)
      } else {
        visibleFolders.insert(folder)
      }
    }
    
    visibleFoldersSorted = Array(visibleFolders).sorted(by: { $0.name > $1.name })
    addCollectionView()
  }
}

extension AlbumsViewController: CreateFolderDelegate {
  func didCreate() {
    var folders = fileService.folders()
    
    for (i, folder) in folders.enumerated() {
      if let accesscodeHash = UserDefaults.standard.object(forKey: folder.name) as? String {
        folders[i].accesscodeHash = accesscodeHash
        hiddenFolders.insert(folders[i])
      } else {
        visibleFolders.insert(folders[i])
      }
    }
    
    visibleFoldersSorted = Array(visibleFolders).sorted(by: { $0.name > $1.name })
    collectionView.reloadData()
  }
}

extension AlbumsViewController: UnlockHiddenFolderDelegate {
  func didEnter(folderCodeHash: String) {
    
    for folder in hiddenFolders {
      if folder.accesscodeHash == folderCodeHash {
        visibleFolders.insert(folder)
        hiddenFolders.remove(folder)
      }
    }
    
    visibleFoldersSorted = Array(visibleFolders).sorted(by: { $0.name > $1.name })
    collectionView.reloadData()
  }
}

extension AlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return visibleFolders.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_Id", for: indexPath) as! AlbumsCollectionViewCell
    cell.name = visibleFoldersSorted[indexPath.row].name
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let index = indexPath.row
    
    let filesViewController = FilesViewController(folderPath: visibleFoldersSorted[index].path)
    navigationController?.pushViewController(filesViewController, animated: true)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = 80
    
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5.0
  }
  
}
