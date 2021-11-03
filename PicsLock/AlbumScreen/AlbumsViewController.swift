import UIKit

final class AlbumsViewController: UIViewController {
    private let viewModel: AlbumsViewModelProtocol
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .background
        
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        
        return collectionView
    }()
    
    init(viewModel: AlbumsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !viewModel.loggedIn {
            if UserDefaults.standard.string(forKey: "codeHash") == nil {
                let setPasscodeViewController = SetPasscodeViewController()
                setPasscodeViewController.delegate = viewModel
                navigationController?.present(setPasscodeViewController, animated: true)
            }
            else {
                login()
            }
        }
    }
    
    private func login() {
        let loginViewController = LoginViewController()
        loginViewController.delegate = viewModel
        loginViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(loginViewController, animated:true, completion: nil)
    }
    
    private func addCollectionView() {
        setNeedsStatusBarAppearanceUpdate()
        
        collectionView.register(AlbumsCollectionViewCell.self, forCellWithReuseIdentifier: "cell_Id")
        view.addSubview(collectionView)
        
        setupNavigationItems()
        setupLayout()
    }
    
    @objc private func newFolder() {
        let createFolderViewController = CreateFolderViewController()
        createFolderViewController.modalPresentationStyle = .overCurrentContext
        createFolderViewController.delegate = viewModel
        present(createFolderViewController, animated:true, completion: nil)
    }
    
    @objc private func unlock() {
        let unlockHiddenFolderViewController = UnlockHiddenFolderViewController()
        unlockHiddenFolderViewController.modalPresentationStyle = .overCurrentContext
        unlockHiddenFolderViewController.delegate = viewModel
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

extension AlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.visibleFolders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_Id", for: indexPath) as! AlbumsCollectionViewCell
        cell.name = viewModel.visibleFoldersSorted[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let filesViewController = FilesViewController(folderPath: viewModel.visibleFoldersSorted[index].path)
        navigationController?.pushViewController(filesViewController, animated: true)
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


extension AlbumsViewController: AlbumsViewModelDelegate {
    func didLoadData() {
        collectionView.reloadData()
    }
    
    func loggedIn() {
        addCollectionView()
    }
}
