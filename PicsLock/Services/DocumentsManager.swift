import Foundation

struct DocumentsManager {
    
    static var documentsURL: URL? {
        try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    func saveDocument(_ document: Document, forName name: String) -> Document? {
        var directory = document.path
        directory.deleteLastPathComponent()
        
        let destinationPath = directory.appendingPathComponent(name)
        
        try? FileManager.default.moveItem(at: document.path, to: destinationPath)
        return Document(name: name, path: destinationPath, image: document.image)
    }
    
}
