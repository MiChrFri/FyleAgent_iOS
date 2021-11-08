import UIKit

final class Button: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        titleLabel?.font = .textButton
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2.0
        clipsToBounds = true
    }
    
}
