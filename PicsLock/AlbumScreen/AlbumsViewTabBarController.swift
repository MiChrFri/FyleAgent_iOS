import UIKit

class AlbumsViewTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = AlbumsViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
        let secondViewController = SearchViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let tabBarList = [firstViewController, secondViewController]
        viewControllers = tabBarList
    }
}
