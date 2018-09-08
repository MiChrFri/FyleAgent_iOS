import Foundation

struct Folder: Hashable {
    let name:String
    let path:URL
    var accesscodeHash: String?

    init(name: String, path: URL) {
        self.name = name
        self.path = path
    }

    var hashValue: Int {
        return name.hashValue
    }

    static func ==(lhs: Folder, rhs: Folder) -> Bool {
        return lhs.name == rhs.name
    }
}
