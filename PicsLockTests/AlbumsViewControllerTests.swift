import XCTest
import UIKit
@testable import PicsLock

class AlbumsViewControllerTests: XCTestCase {
    var viewController = AlbumsViewController(viewModel: AlbumsViewModelMock())
    
    override func setUp() {
        super.setUp()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = viewController
        
        let _ = navigationController.view
        let _ = viewController.view
    }
    
    func testViewControllerNotNil() {
        XCTAssertNotNil(viewController.view)
    }
    
    func testCollectionViewNotNil() {
        XCTAssertNotNil(viewController.collectionView)
    }
    
    func testNumberOfCollectionViewCells() {
        XCTAssertEqual(0, viewController.collectionView.numberOfItems(inSection: 0))
    }
    
}


final class AlbumsViewModelMock: AlbumsViewModelProtocol {
    var loggedIn = false
    
    var visibleFolders = Set<Folder>()
    
    var visibleFoldersSorted = [Folder]()
    
    var delegate: AlbumsViewModelDelegate?
    
    func successfullyLoggedIn() {
        
    }
    
    func didCreate() {

    }
    
    func didEnter(folderCodeHash: String) {
    }
    
}
