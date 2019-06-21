import Foundation

enum SettingsSection: Int, CaseIterable {
    case account = 0
    case general = 1
    
    enum Account: Int {
        case passwordEdit = 0
        case emailEdit = 1
    }
    
    enum General: Int {
        case logout = 0
    }
}

extension SettingsSection {
    var title: String {
        switch self {
        case .account:
            return "アカウント"
        case .general:
            return "一般"
        }
    }
}

protocol Item {
    var title: String { get }
}

class AccountItem: Item {
    
    let title: String
    
    private init(title: String) {
        self.title  = title
    }
    
    class var sharedItems: [AccountItem] {
        struct Static {
            static let items = AccountItem.sharedMenuItems()
        }
        return Static.items
    }
    
    private class func sharedMenuItems() -> [AccountItem] {
        var items = [AccountItem]()
        items.append(AccountItem(title: "パスワード変更"))
        items.append(AccountItem(title: "メールアドレス変更"))
        
        return items
    }
}

class GeneralItem: Item {
    
    let title: String
    
    private init(title: String) {
        self.title  = title
    }
    
    class var sharedItems: [GeneralItem] {
        struct Static {
            static let items = GeneralItem.sharedMenuItems()
        }
        return Static.items
    }
    
    private class func sharedMenuItems() -> [GeneralItem] {
        var items = [GeneralItem]()
        items.append(GeneralItem(title: "ログアウト"))
        
        return items
    }
}
