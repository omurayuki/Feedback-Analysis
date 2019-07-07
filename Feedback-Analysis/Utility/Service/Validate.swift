import Foundation

enum AccountValidation {
    case ok(String, String?, String?)
    case notAccurateChar(String)
    case mailNotEnough(String)
    case passNotEnough(String)
    case mailExceeded(String)
    case passExceeded(String)
    
    static func validateAccount(email: String, pass: String? = nil, rePass: String? = nil) -> AccountValidation {
        guard email.count > 1 else { return .mailNotEnough("メールアドレスを記入してください") }
        guard email.count < 50 else { return .mailExceeded("メールアドレスは50文字以内で記入してください") }
        if let pass = pass {
            guard pass.count > 5 else { return .passNotEnough("パスワードは5文字以上で記入してください") }
            guard pass.count < 50 else { return .passExceeded("パスワードは50文字以内で記入してください") }
        }
        if let rePass = rePass {
            guard rePass.count > 5 else { return .passNotEnough("パスワードは5文字以上で記入してください") }
            guard rePass.count < 50 else { return .passExceeded("パスワードは50文字以内で記入してください") }
        }
        guard NSPredicate(format: "SELF MATCHES %@", "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
            .evaluate(with: email) else { return .notAccurateChar("emailの形式が間違っています") }
        return .ok(email, pass, rePass)
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
        guard name.count <= 15 else { return .nameExceeded("名前は15文字以内で記入してください") }
        guard content.count < 100 else { return .contentExceeded("自己紹介は100字以内で記入してください") }
        return .ok(name, content, residence, birth)
    }
}

enum GoalPostValidation {
    case ok(Array<String>, String?, String?, String?, String?)
    case empty(String)
    case exceeded(String)
    
    static func validate(genre: [String], newThings: String? = nil,
                         expectedResult1: String? = nil, expectedResult2: String? = nil,
                         expectedResult3: String? = nil) -> GoalPostValidation {
        guard genre.count == 2 else { return .empty("ジャンルを2つ選択してください") }
        if let newThings = newThings, let expectedResult1 = expectedResult1, let expectedResult2 = expectedResult2, let expectedResult3 = expectedResult3 {
            guard newThings.count > 1 && expectedResult1.count > 1 && expectedResult2.count > 1 && expectedResult3.count > 1 else { return .empty("空白を埋めてください") }
            guard newThings.count <= 25 else { return .exceeded("25文字以下で入力してください") }
            guard expectedResult1.count <= 25 else { return .exceeded("25文字以下で入力してください") }
            guard expectedResult2.count <= 25 else { return .exceeded("25文字以下で入力してください") }
            guard expectedResult3.count <= 25 else { return .exceeded("25文字以下で入力してください") }
        }
        return .ok(genre, newThings, expectedResult1, expectedResult2, expectedResult3)
    }
}
