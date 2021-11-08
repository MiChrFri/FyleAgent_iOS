import UIKit

final class InputField: UITextField {

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .textBackgroundLight
        self.layer.cornerRadius = 8.0
        self.textColor = .lightText
        self.font = .inputField
        self.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.padding)
    }

    private enum Constants {
        static let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
}
