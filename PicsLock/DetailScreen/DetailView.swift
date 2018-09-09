import UIKit
import ZoomImageView

class DetailView: UIView {

    lazy var scrollView: ZoomImageView = {
        let scrollView = ZoomImageView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var nameField: InputField = {
        let nameField = InputField()
        nameField.placeholder = "Foldername"
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()

    init(image: UIImage, name: String) {
        super.init(frame: CGRect.zero)

        self.addSubview(scrollView)
        self.addSubview(nameField)
        nameField.text = name
        scrollView.image = image

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            nameField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        ])
    }

}

