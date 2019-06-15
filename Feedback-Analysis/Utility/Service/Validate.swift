import Foundation

enum AccountValidation {
    case ok(String, String?)
    case notAccurateChar(String)
    case mailNotEnough(String)
    case passNotEnough(String)
    case mailExceeded(String)
    case passExceeded(String)
    
    static func validateAccount(email: String, pass: String? = nil) -> AccountValidation {
        guard email.count > 1 else { return .mailNotEnough("メールアドレスを記入してください") }
        guard email.count < 50 else { return .mailExceeded("メールアドレスが長すぎます") }
        if let pass = pass {
            guard pass.count > 5 else { return .passNotEnough("パスワードが短すぎます") }
            guard pass.count < 50 else { return .passExceeded("パスワードが長すぎます") }
        }
        guard NSPredicate(format: "SELF MATCHES %@", "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
            .evaluate(with: email) else { return .notAccurateChar("emailの形式が間違っています") }
        return .ok(email, pass)
    }
}

enum UserValidation {
    case ok(String, String, String, String)
    case empty(String)
    case nameExceeded(String)
    case contentExceeded(String)
    
    static func validateUser(name: String, content: String,
                             residence: String, birth: String) -> UserValidation {
        guard name.count > 1 || content.count > 1 || residence.count > 1 || birth.count > 1 else { return .empty("空白を埋めてください") }
        guard name.count < 15 else { return .nameExceeded("名前が長すぎます") }
        guard content.count < 140 else { return .contentExceeded("自己紹介が長すぎます") }
        return .ok(name, content, residence, birth)
    }
}
