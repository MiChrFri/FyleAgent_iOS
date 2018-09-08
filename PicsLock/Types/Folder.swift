import Foundation

struct Folder {
    let name:String
    let path:URL
    var accesscodeHash: String?

    init(name: String, path: URL) {
        self.name = name
        self.path = path
    }
}
