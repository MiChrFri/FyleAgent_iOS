import UIKit

class FilesViewController: UIViewController {
    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let fileService = FileService()
    
    var files = [File]()
    let folderPath: URL
    
    
    init(folderPath: URL) {
        self.folderPath = folderPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        files = fileService.files(at: folderPath)
        addCollectionView()
    }
    
    func addCollectionView() {
        collectionView.register(FilesCollectionViewCell.self, forCellWithReuseIdentifier: "files_cell_Id")
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.backgroundColor = Color.Dark.background
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
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
}

extension FilesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "files_cell_Id", for: indexPath) as! FilesCollectionViewCell
        
        if let img = UIImage(contentsOfFile: files[indexPath.row].path.relativePath) {
            cell.composeView(withImage: img)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        if let img = UIImage(contentsOfFile: files[index].path.relativePath) {
            let detailViewController = DetailViewController(image: img)
            
            let transition = CATransition()
            transition.duration = 0.1
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)

            
            self.navigationController?.pushViewController(detailViewController, animated: false)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 3 - 16
        
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
