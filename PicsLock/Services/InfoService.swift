import GSMessages

struct InfoService {
    private let view: UIView?
    private let viewController: UIViewController?

    init(view: UIView) {
        self.view = view
        self.viewController = nil
        setColors()
    }

    init(viewController: UIViewController) {
        self.viewController = viewController
        self.view = nil
        setColors()
    }

    private func setColors() {
        GSMessage.successBackgroundColor = Color.Dark.successBackground
        GSMessage.warningBackgroundColor = Color.Dark.warningBackground
        GSMessage.errorBackgroundColor   = Color.Dark.errorBackground
        GSMessage.infoBackgroundColor    = Color.Dark.infoBackground
    }

    func showInfo(message: String, type: GSMessageType) {

        if let vc = viewController {
            vc.showMessage(message, type: type, options: [
                .animation(.slide),
                .animationDuration(0.3),
                .autoHide(true),
                .autoHideDelay(0.9),
                .height(22.0),
                .margin(.zero),
                .padding(.init(top: 2, left: 30, bottom: 2, right: 30)),
                .position(.top),
                .textAlignment(.center),
                .textColor(.white),
            ])
        } else {
            view?.showMessage(message, type: type, options: [
                .animation(.slide),
                .animationDuration(0.3),
                .autoHide(true),
                .autoHideDelay(0.6),
                .height(44.0),
                .margin(.zero),
                .padding(.init(top: 18, left: 30, bottom: 2, right: 30)),
                .position(.top),
                .textAlignment(.center),
                .textColor(.white),
            ])
        }
    }
}

