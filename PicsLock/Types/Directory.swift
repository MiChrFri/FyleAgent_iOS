import Foundation

protocol Directory {
  var name: String { get }
  var path: URL { get }
}
