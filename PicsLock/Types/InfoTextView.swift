import UIKit

class InfoTextView: UITextView {

    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        self.isUserInteractionEnabled = false
        self.textAlignment = .center
        self.isUserInteractionEnabled = true
        self.backgroundColor = .alertBackground
        self.textColor = .lightText
        self.font = .infoText
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
