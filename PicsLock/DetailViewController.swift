import UIKit

class DetailViewController: UIViewController {
    let image: UIImage!
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = self.image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(imageView)
        setupLayout()
        
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)

        _ = navigationController?.popViewController(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
