import UIKit

private enum Constants {
  static let margin: CGFloat = 2.0
}

final class AlbumsCollectionViewCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    composeView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var name:String? {
    didSet {
      infoLabel.text = name
    }
  }
  
  private func composeView() {
    contentView.addSubview(infoLabel)
    contentView.layer.masksToBounds = true
    
    let imageView = folderImageView
    imageView.image = UIImage(named: "folder.png")
    contentView.addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(Constants.margin + 30)),
      
      infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
      infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
      infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
      infoLabel.heightAnchor.constraint(equalToConstant: 30.0),
    ])
  }
  
  private let folderImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var infoLabel: UILabel = {
    let infoLabel = UILabel()
    infoLabel.textAlignment = .center
    infoLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    infoLabel.numberOfLines = 2
    infoLabel.font = UIFont.systemFont(ofSize: 12.0)
    infoLabel.translatesAutoresizingMaskIntoConstraints = false
    return infoLabel
  }()
  
}
