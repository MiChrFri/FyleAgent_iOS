import Foundation

extension URL {
    
    func dataPath() -> String {
        var path = "."
        let components = pathComponents
        var append = false
            
        for component in components {
            if append {
                path += ("/\(component)")
            } else if component == "Documents" {
                append = true
            }
        }
        
        return path
    }

}
