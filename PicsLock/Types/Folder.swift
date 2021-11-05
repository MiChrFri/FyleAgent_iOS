import Foundation

struct Folder: Directory, Hashable {
    let name:String
    let path:URL
    var accesscodeHash: String?
    
    init(name: String, path: URL) {
        self.name = name
        self.path = path
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}
