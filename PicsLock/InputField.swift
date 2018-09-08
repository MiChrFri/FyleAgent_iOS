import UIKit

class InputField: UITextField {
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = Color.Dark.textBackground
        self.textColor = Color.Dark.lightText
        self.font = Font.inputField
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}