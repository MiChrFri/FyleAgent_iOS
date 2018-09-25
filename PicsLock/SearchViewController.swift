import UIKit

class SearchViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "hoila"
    
    var wohoo = [String]()
    var candies = ["hello", "bert", "aha", "alhambra", "amalia"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        navigationItem.searchController = searchController
        definesPresentationContext = true

        view.backgroundColor = UIColor.red
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        wohoo = candies.filter({( candy : String) -> Bool in
            return candy.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
            cell?.detailTextLabel?.text = wohoo[indexPath.row]
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wohoo.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

//extension SearchViewController: UISearchResultsUpdating {
//}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
