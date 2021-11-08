import Foundation
import UIKit

struct FileService {
    private let fileManager = FileManager.default
    private let resourceKeys: [URLResourceKey] = [.creationDateKey, .isDirectoryKey, .fileSizeKey]
    
    func folders(at path: URL? = DocumentsManager.documentsURL) -> [Folder] {
        guard let path = path, let enumerator = enumerator(forUrl: path) else { return [] }
        var folders = [Folder]()
        
        for case let url as URL in enumerator {
            let resourceValues = try? url.resourceValues(forKeys: Set(resourceKeys))
            if resourceValues?.isDirectory ?? false {
                folders.append(Folder(name: url.lastPathComponent, path: url.absoluteURL))
            }
        }
        
        return folders
    }
    
    func createFolder(folderName: String, codeHash: String?, at path: URL? = DocumentsManager.documentsURL) {
        guard let folder = path?.appendingPathComponent(folderName) else { return }
        
        try? FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
        if let accesscodeHash = codeHash {
            UserDefaults.standard.set(accesscodeHash, forKey: folderName)
        }
    }
    
    func files(at path: URL) -> [File] {
        guard let enumerator = enumerator(forUrl: path) else { return [] }
        var files = [File]()
        
        for case let fileURL as URL in enumerator {
            let resourceValues = try? fileURL.resourceValues(forKeys: Set(resourceKeys))
            if !(resourceValues?.isDirectory ?? false) {
                let fileType = detectFileType(from: fileURL.pathExtension)
                files.append(File(name: fileURL.lastPathComponent, path: fileURL.absoluteURL, type: fileType, thumbnail: UIImage(contentsOfFile: fileURL.relativePath)))
            }
        }
        
        return files
    }

    private func detectFileType(from fileExtension: String) -> FileType {
        switch fileExtension {
        case "png", "jpg": return .image
        default: return .video
        }
    }
    
    private func enumerator(forUrl url: URL) -> FileManager.DirectoryEnumerator? {
        return FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: resourceKeys,
            options: [.skipsHiddenFiles],
            errorHandler: nil)
    }
    
}


