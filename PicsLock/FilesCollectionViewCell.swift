import UIKit

class FilesCollectionViewCell: UICollectionViewCell {
    let margin:CGFloat = 2.0
    
    func composeView(withImage image: UIImage) {
        self.contentView.layer.masksToBounds = true
        let mv = UIImageView(image: image)
        
        mv.contentMode = .scaleAspectFill
        mv.clipsToBounds = true
        contentView.addSubview(mv)
        mv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
            mv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
            mv.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            mv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
        ])
    }
}
