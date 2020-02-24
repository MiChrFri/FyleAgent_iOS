import Foundation

struct FileService {
    let fileManager = FileManager.default
    
    func documentDirectories() -> [Folder] {
        var folders = [Folder]()
        
        do {
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey, .fileSizeKey]
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let enumerator = FileManager.default.enumerator(at: documentsURL,
                                                            includingPropertiesForKeys: resourceKeys,
                                                            options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                                print("directoryEnumerator error at \(url): ", error)
                                                                return true
            })!
            
            for case let url as URL in enumerator {
                let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
                if resourceValues.isDirectory ?? false {
                    folders.append(Folder(name: url.lastPathComponent, path: url.absoluteURL))
                }
                
            }
        } catch {
            print(error)
        }
        
        return folders
    }
    
    func files(at documentsURL: URL ) -> [File] {
        var files = [File]()
        
        do {
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey, .fileSizeKey]
            let enumerator = FileManager.default.enumerator(at: documentsURL,
                                                            includingPropertiesForKeys: resourceKeys,
                                                            options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                                return true
            })!
            
            for case let fileURL as URL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                if !(resourceValues.isDirectory ?? false) {
                    
                    files.append(File(name: fileURL.lastPathComponent, path: fileURL.absoluteURL))
                }
            }
        } catch {
            print(error)
        }
        
        return files
    }
}


