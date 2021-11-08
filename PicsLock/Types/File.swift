import Foundation
import UIKit

struct File: Directory {
    let fallback = UIImage(systemName: "photo")

    init(name: String, path: URL, type: FileType, thumbnail: UIImage?) {
        self.name = name
        self.path = path
        self.type = type
        self.thumbnail = thumbnail ?? fallback
    }

    var name: String
    var path: URL
    var type: FileType
    var thumbnail: UIImage?
}

enum FileType {
    case image, video
}
