import XCTest
@testable import PicsLock

class StringTests: XCTestCase {
  
  func testSha256() {
    guard let testHash = "hello world".sha256() else { XCTFail(); return }
    let expected = "SHA256 digest: b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9"
    XCTAssertEqual(testHash, expected)
  }
  
}
