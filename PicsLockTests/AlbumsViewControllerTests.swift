import XCTest
import UIKit
@testable import PicsLock

class AlbumsViewControllerTests: XCTestCase {
    var viewController: AlbumsViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = AlbumsViewController()
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
