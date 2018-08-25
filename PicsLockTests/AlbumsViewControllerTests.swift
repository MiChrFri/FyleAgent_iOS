import XCTest
import UIKit
@testable import PicsLock

class AlbumsViewControllerTests: XCTestCase {
    var viewController: AlbumsViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = AlbumsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        let _ = navigationController.view
        let _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewControllerNotNil() {
        XCTAssertNotNil(viewController.view)
    }
    
    func testCollectionViewNotNil() {
        XCTAssertNotNil(viewController.collectionView)
    }
    
    func testNumberOfCollectionViewCells() {
        XCTAssertEqual(viewController.collectionView.numberOfItems(inSection: 0), 4)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
