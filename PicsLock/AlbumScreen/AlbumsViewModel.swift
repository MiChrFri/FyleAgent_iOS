import UIKit

protocol AlbumsViewModelDelegate: AnyObject {
    func didLoadData()
    
    func loggedIn()
}

protocol AlbumsViewModelProtocol: LoginDelegate, CreateFolderDelegate, UnlockHiddenFolderDelegate {
    var loggedIn: Bool { get }
    var visibleFolders: Set<Folder> { get }
    var visibleFoldersSorted: [Folder] { get }
    var delegate: AlbumsViewModelDelegate? { get set }
}

final class AlbumsViewModel: AlbumsViewModelProtocol {
    private(set) var loggedIn = false
    private(set) lazy var fileService = FileService()
    
    private var hiddenFolders: Set<Folder> = []
    private(set) var visibleFolders: Set<Folder> = []
    private(set) var visibleFoldersSorted = [Folder]()
    
    var delegate: AlbumsViewModelDelegate?
}


extension AlbumsViewModel: LoginDelegate {
    func successfullyLoggedIn() {
        loggedIn = true
        let folders = fileService.folders()
        
        for folder in folders {
            if let accesscodeHash = UserDefaults.standard.object(forKey: folder.name) as? String {
                var f = folder
                f.accesscodeHash = accesscodeHash
                hiddenFolders.insert(f)
            } else {
                visibleFolders.insert(folder)
            }
        }
        
        visibleFoldersSorted = Array(visibleFolders).sorted(by: { $0.name > $1.name })
        delegate?.loggedIn()
    }
}

extension AlbumsViewModel: CreateFolderDelegate {
    func didCreate() {
        var folders = fileService.folders()
        
        for (i, folder) in folders.enumerated() {
            if let accesscodeHash = UserDefaults.standard.object(forKey: folder.name) as? String {
                folders[i].accesscodeHash = accesscodeHash
                hiddenFolders.insert(folders[i])
            } else {
                visibleFolders.insert(folders[i])
            }
        }
        
        visibleFoldersSorted = Array(visibleFolders).sorted(by: { $0.name > $1.name })
        delegate?.didLoadData()
    }
}

extension AlbumsViewModel: UnlockHiddenFolderDelegate {
    func didEnter(folderCodeHash: String) {
        
        for folder in hiddenFolders {
            if folder.accesscodeHash == folderCodeHash {
                visibleFolders.insert(folder)
                hiddenFolders.remove(folder)
            }
        }
        
        visibleFoldersSorted = Array(visibleFolders).sorted(by: { $0.name > $1.name })
        delegate?.didLoadData()
    }
}


