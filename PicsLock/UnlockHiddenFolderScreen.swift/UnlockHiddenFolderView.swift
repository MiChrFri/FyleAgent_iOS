import UIKit

protocol UnlockHiddenFolderViewDelegate: AnyObject {
  func didEnter(codeHash: String?)
  func didClose()
}

class UnlockHiddenFolderView: UIView {
  weak var delegate: UnlockHiddenFolderViewDelegate?
  
  lazy var backgroundView: UIView = {
    let backgroundView = UIView(frame: CGRect.zero)
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    return backgroundView
  }()
  
  lazy var passcodeView: UIView = {
    let passcodeView = UIView(frame: CGRect.zero)
    passcodeView.backgroundColor = .alertBackground
    passcodeView.layer.cornerRadius = 12.0
    passcodeView.translatesAutoresizingMaskIntoConstraints = false
    return passcodeView
  }()
  
  lazy var closeButton: UIButton = {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
    let largeBoldDoc = UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig)
    
    let closeButton = UIButton(frame: CGRect.zero)
    closeButton.setImage(largeBoldDoc, for: .normal)
    closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    return closeButton
  }()
  
  lazy var infoTextView: InfoTextView = {
    let infoTextView = InfoTextView()
    infoTextView.text = "Enter your passcode for you hidden folder to show them temporary in the folder-overview"
    infoTextView.translatesAutoresizingMaskIntoConstraints = false
    return infoTextView
  }()
  
  lazy var folderCode: InputField = {
    let folderCode = InputField()
    folderCode.placeholder = "FolderCode"
    folderCode.isSecureTextEntry = true
    folderCode.translatesAutoresizingMaskIntoConstraints = false
    return folderCode
  }()
  
  lazy var doneButton: UIButton = {
    let doneButton = UIButton(frame: CGRect.zero)
    doneButton.layer.cornerRadius = 8.0
    doneButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    doneButton.setTitle("Unlock", for: .normal)
    doneButton.titleLabel?.font = .textButton
    doneButton.addTarget(self, action: #selector(doneEntering), for: .touchUpInside)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    return doneButton
  }()
  
  init() {
    super.init(frame: CGRect.zero)
    
    self.addSubview(backgroundView)
    self.addSubview(passcodeView)
    passcodeView.addSubview(closeButton)
    passcodeView.addSubview(infoTextView)
    passcodeView.addSubview(folderCode)
    passcodeView.addSubview(doneButton)
    folderCode.becomeFirstResponder()
    
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func closeView() {
    delegate?.didClose()
  }
  
  @objc func doneEntering() {
    if let folderCode = folderCode.text {
      if folderCode.count > 0 {
        let passcodeHash = folderCode.sha256()
        delegate?.didEnter(codeHash: passcodeHash)
      }
    }
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      passcodeView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30.0),
      passcodeView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30.0),
      passcodeView.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 60.0),
      passcodeView.bottomAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 50.0),
      
      closeButton.topAnchor.constraint(equalTo: passcodeView.topAnchor, constant: 8.0),
      closeButton.trailingAnchor.constraint(equalTo: passcodeView.trailingAnchor, constant: -8.0),
      closeButton.widthAnchor.constraint(equalToConstant: 40.0),
      closeButton.heightAnchor.constraint(equalToConstant: 40.0),
      
      doneButton.bottomAnchor.constraint(equalTo: passcodeView.bottomAnchor, constant: -12.0),
      doneButton.centerXAnchor.constraint(equalTo: passcodeView.centerXAnchor),
      doneButton.widthAnchor.constraint(equalToConstant: 100.0),
      doneButton.heightAnchor.constraint(equalToConstant: 40.0),
      
      folderCode.leadingAnchor.constraint(equalTo: passcodeView.leadingAnchor, constant: 16.0),
      folderCode.trailingAnchor.constraint(equalTo: passcodeView.trailingAnchor, constant: -16.0),
      folderCode.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -34.0),
      folderCode.centerXAnchor.constraint(equalTo: passcodeView.centerXAnchor),
      
      infoTextView.leadingAnchor.constraint(equalTo: passcodeView.leadingAnchor, constant: 16.0),
      infoTextView.trailingAnchor.constraint(equalTo: passcodeView.trailingAnchor, constant: -16.0),
      infoTextView.bottomAnchor.constraint(equalTo: folderCode.topAnchor, constant: -20.0),
      infoTextView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24.0),
      infoTextView.centerXAnchor.constraint(equalTo: passcodeView.centerXAnchor),
    ])
  }
  
}

