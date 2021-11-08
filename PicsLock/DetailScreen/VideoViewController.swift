import UIKit
import AVKit
import AVFoundation

final class VideoViewController: UIViewController {

    let filePath: URL

    var nameField: NameField = {
        let nameField = NameField()
        nameField.placeholder = "Foldername"
        nameField.isUserInteractionEnabled = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()

    var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(with filePath: URL) {
        self.filePath = filePath
        super.init(nibName: nil, bundle: nil)

        view.addSubview(playButton)

        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func playVideo() {
        if let filepath = Bundle.main.path(forResource: "sample", ofType: "m4v") {
            let player = AVPlayer(url: URL(fileURLWithPath: filepath))
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        } else {
            print("asdasdasd")
        }

    }
}
