import Foundation

enum AccountValidation {
    case ok(String, String)
    case notAccurateChar(String)
    case mailNotEnough(String)
    case passNotEnough(String)
    case mailExceeded(String)
    case passExceeded(String)
}

struct Validate {
    static func validateAccount(mail: String, pass: String) -> AccountValidation {
        guard mail.count > 1 else { return .mailNotEnough("メールアドレスを記入してください") }
        guard mail.count < 50 else { return .mailExceeded("メールアドレスが長すぎます") }
        guard pass.count > 5 else { return .passNotEnough("パスワードが短すぎます") }
        guard pass.count < 50 else { return .passExceeded("パスワードが長すぎます") }
        guard NSPredicate(format: "SELF MATCHES %@", "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
            .evaluate(with: mail) else { return .notAccurateChar("emailの形式が間違っています") }
        return .ok(mail, pass)
    }
}
