import UIKit

class SearchViewController: UIViewController {
    let fileService = FileService()
    
    var allFiles = [String: URL]()
    var allFileNames = [String]()
    var searchResults = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "searchResults"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        view.backgroundColor = .alertBackground
        tableView.backgroundColor = .background
        tableView.separatorColor = .alertBackground
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        for folder in fileService.folders() {
            if UserDefaults.standard.object(forKey: folder.name) == nil {
                for file in fileService.files(at: folder.path) {
                    allFiles[file.name] = file.path
                    allFileNames.append(file.name)
                }
            }
        }
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search documents"
        
        let txfSearchField = searchController.searchBar.searchTextField
        txfSearchField.backgroundColor = .nameFieldBackground
        txfSearchField.textColor = UIColor.white
        
        let leftIcon = txfSearchField.leftView as! UIImageView
        leftIcon.image = leftIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        leftIcon.tintColor = .navBarItems
        
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchResults = allFileNames.filter({( fileName : String) -> Bool in
            return fileName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchController.searchBar.text = ""
        searchController.isActive = false
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.init(red: 67.0/255.0, green: 68.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            let fileName = searchResults[indexPath.row]
            let path = allFiles[fileName]
            
            cell?.textLabel?.text = fileName
            cell?.textLabel?.textColor = UIColor.white.withAlphaComponent(1.0)
            
            cell?.detailTextLabel?.text = path?.dataPath()
            cell?.textLabel?.textColor = UIColor.gray.withAlphaComponent(1.0)
            
            if let img = UIImage(contentsOfFile: path?.relativePath ?? "") {
                cell?.imageView?.image = img
                cell?.imageView?.contentMode = .scaleAspectFit
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fileName = searchResults[indexPath.row]
        
        if let path = allFiles[fileName] {
            if let img = UIImage(contentsOfFile: path.relativePath) {
                let document = Document(name: path.lastPathComponent, path: path, image: img)
                
                let detailViewController = DetailViewController(document: document)
                
                let transition = CATransition()
                transition.duration = 0.1
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                transition.type = CATransitionType.fade
                self.navigationController?.view.layer.add(transition, forKey: nil)
                
                
                self.navigationController?.pushViewController(detailViewController, animated: false)
            }
        }
        
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
