import Foundation
import UIKit

struct ContentCreator {
    
    static func addTextContent() {
        for i in 0...5 {
            if let img = UIImage(named: "testImg") {
                ContentCreator.saveImage(image: img, forName: "test_\(i).png")
            }
        }
    }
    
    private static func saveImage(image: UIImage, forName name: String) {
        guard let data = UIImageJPEGRepresentation(image, 0.5) ?? UIImagePNGRepresentation(image) else {return}
        do {
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let folder1 = documentsDirectory.appendingPathComponent("MyFolder")
            let folder2 = documentsDirectory.appendingPathComponent("MyFolder_cpy")
            
            do {
                try FileManager.default.createDirectory(atPath: folder1.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
            
            do {
                try FileManager.default.createDirectory(atPath: folder2.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
            
            
            let imagePath = folder1.appendingPathComponent(name)
            try data.write(to: imagePath)
            
            let imagePath2 = folder2.appendingPathComponent(name)
            try data.write(to: imagePath2)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
