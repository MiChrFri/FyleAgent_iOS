import UIKit

class DetailViewController: UIViewController {

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)

        view = DetailView(image: image)
        setupNavigationItems()
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

    private func setupNavigationItems() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

}

