import Foundation

struct FileService {
  private let fileManager = FileManager.default
  private let resourceKeys: [URLResourceKey] = [.creationDateKey, .isDirectoryKey, .fileSizeKey]
  
  var folders: [Folder] {
    guard let documentsURL = DocumentsManager.documentsURL,
    let enumerator = enumerator(forUrl: documentsURL) else { return [] }
    var folders = [Folder]()
    
    for case let url as URL in enumerator {
      let resourceValues = try? url.resourceValues(forKeys: Set(resourceKeys))
      if resourceValues?.isDirectory ?? false {
        folders.append(Folder(name: url.lastPathComponent, path: url.absoluteURL))
      }
    }
    
    return folders
  }
  
  func files(at documentsURL: URL ) -> [File] {
    guard let enumerator = enumerator(forUrl: documentsURL) else { return [] }
    var files = [File]()
    
    for case let fileURL as URL in enumerator {
      let resourceValues = try? fileURL.resourceValues(forKeys: Set(resourceKeys))
      if !(resourceValues?.isDirectory ?? false) {
        files.append(File(name: fileURL.lastPathComponent, path: fileURL.absoluteURL))
      }
    }
    
    return files
  }
  
  private func enumerator(forUrl url: URL) -> FileManager.DirectoryEnumerator? {
    return FileManager.default.enumerator(
      at: url,
      includingPropertiesForKeys: resourceKeys,
      options: [.skipsHiddenFiles],
      errorHandler: nil)
  }
  
}


