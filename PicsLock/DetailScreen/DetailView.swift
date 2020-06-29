import UIKit

class DetailView: UIView {
  
  let zoomView: ZoomView = {
    let scrollView = ZoomView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  let nameField: NameField = {
    let nameField = NameField()
    nameField.placeholder = "Foldername"
    nameField.isUserInteractionEnabled = false
    nameField.translatesAutoresizingMaskIntoConstraints = false
    return nameField
  }()
  
  init(image: UIImage, name: String) {
    super.init(frame: CGRect.zero)
    
    self.addSubview(zoomView)
    self.addSubview(nameField)
    nameField.text = name
    zoomView.image = image
    
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      zoomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      zoomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      zoomView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      zoomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      nameField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      nameField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      nameField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      nameField.heightAnchor.constraint(equalToConstant: 40.0),
    ])
  }
  
}

