import UIKit

class AlbumsViewController: UIViewController {
    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var folders = [Folder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        ContentCreator.addTextContent()
        #endif
        
        let fileService = FileService()
        folders = fileService.documentDirectories()

        
        addCollectionView()
    }
    
    func addCollectionView() {
        setNeedsStatusBarAppearanceUpdate()
        
        collectionView.register(AlbumsCollectionViewCell.self, forCellWithReuseIdentifier: "cell_Id")
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Color.Dark.background
        
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        self.view.addSubview(collectionView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension AlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_Id", for: indexPath) as! AlbumsCollectionViewCell
        cell.name = folders[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let filesViewController = FilesViewController(folderPath: folders[index].path)
        self.navigationController?.pushViewController(filesViewController, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 80//UIScreen.main.bounds.width / 3 - 26
        
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
