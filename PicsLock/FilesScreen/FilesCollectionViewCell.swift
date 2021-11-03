import UIKit

final class FilesCollectionViewCell: UICollectionViewCell {
    private enum Constants {
        static let padding: CGFloat = 2.0
    }
    
    var name: String? {
        didSet {
            infoLabel.text = name
        }
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
    
    func composeView(withImage image: UIImage) {
        contentView.addSubview(infoLabel)
        self.contentView.layer.masksToBounds = true
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.padding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.padding),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.padding),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(Constants.padding + 30)),
            
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            infoLabel.heightAnchor.constraint(equalToConstant: 30.0),
        ])
    }
    
}
