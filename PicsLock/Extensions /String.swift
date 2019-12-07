import CryptoKit

extension String {
  
  func sha256() -> String? {
    guard let data = self.data(using: .utf8) else { return nil }
    let digest = SHA256.hash(data: data)
    return digest.description
  }
 
}
