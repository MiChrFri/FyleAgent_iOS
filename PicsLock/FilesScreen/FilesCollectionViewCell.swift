import UIKit

class FilesCollectionViewCell: UICollectionViewCell {
    let margin:CGFloat = 2.0
    var name:String? {
        didSet {
            infoLabel.text = name
        }
    }
    
    func composeView(withImage image: UIImage) {
        contentView.addSubview(infoLabel)
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
            mv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(margin + 30)),
            
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            infoLabel.heightAnchor.constraint(equalToConstant: 30.0),
        ])
    }
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel(frame: CGRect.zero)
        infoLabel.textAlignment = .center
        infoLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        infoLabel.numberOfLines = 2
        infoLabel.font = UIFont.systemFont(ofSize: 12.0)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        return infoLabel
    }()
}
