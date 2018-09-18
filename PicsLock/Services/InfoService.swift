import NotificationBannerSwift

struct InfoService {
    func showInfo(message: String, type: BannerStyle) {
        let banner = NotificationBanner(title: message, subtitle: nil, style: .success)
        banner.show()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            banner.dismiss()
        }
        
    }
}

