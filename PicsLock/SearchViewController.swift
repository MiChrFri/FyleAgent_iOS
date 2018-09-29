import UIKit

class SearchViewController: UITableViewController {
    let fileService = FileService()
    
    var allFiles = [String: URL]()
    var allFileNames = [String]()
    var searchResults = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "searchResults"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.Dark.alertBackground
        tableView.backgroundColor = Color.Dark.background
        tableView.separatorColor = Color.Dark.alertBackground
        tableView.bounces = false
        
        
        view.backgroundColor = Color.Dark.alertBackground
        
        let folders = fileService.documentDirectories()
        for folder in folders {
            for file in fileService.files(at: folder.path) {
                allFiles[file.name] = file.path
                allFileNames.append(file.name)
            }
        }
        
        
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = Color.Dark.navBar
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search documents"
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.barTintColor = Color.Dark.navBar
        
        if let txfSearchField = searchController.searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.backgroundColor = Color.Dark.nameFieldBackground
            txfSearchField.textColor = Color.Dark.lightText
            
            let leftIcon = txfSearchField.leftView as! UIImageView
            leftIcon.image = leftIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            leftIcon.tintColor = Color.Dark.navBarItems
        }

        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchResults = allFileNames.filter({( fileName : String) -> Bool in
            return fileName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = Color.Dark.alertBackground
            
            let fileName = searchResults[indexPath.row]
            let path = allFiles[fileName]

            cell?.textLabel?.text = fileName
            cell?.detailTextLabel?.text = path?.dataPath()
            
            print(path?.relativePath ?? "")
        
            if let img = UIImage(contentsOfFile: path?.relativePath ?? "") {
                
                cell?.imageView?.image = img
                
                let itemSize = CGSize.init(width: 25, height: 25)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                cell?.imageView?.image!.draw(in: imageRect)
                cell?.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                UIGraphicsEndImageContext();
                
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension SearchViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1 {
            navigationController?.pushViewController(SearchViewController(), animated: true)
        }
    }
}
