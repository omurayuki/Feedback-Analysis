import Foundation

enum AccountValidation {
    case ok(String, String?)
    case notAccurateChar(String)
    case mailNotEnough(String)
    case passNotEnough(String)
    case mailExceeded(String)
    case passExceeded(String)
}

extension AccountValidation {
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
