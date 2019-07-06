import Foundation

class AppUserDefaults {
    
    // Email
    class func getAccountEmail() -> String {
        return getStringValue(keyName: "AccountEmail")
    }
    
    class func setAccountEmail(email: String) {
        putStringValue(email, keyName: "AccountEmail")
    }
    
    // AuthToken
    class func getAuthToken() -> String {
        return getStringValue(keyName: "AuthToken")
    }
    
    class func setAuthToken(token: String) {
        putStringValue(token, keyName: "AuthToken")
    }
    
    // 初回起動フラグ
    class func getFirstLaunchFrag() -> Bool {
        return getBoolValue(keyName: "FirstLaunch")
    }
    
    class func setFirstLaunchFrag() {
        putBoolValue(true, keyName: "FirstLaunch")
    }
    
    // goalDocumentId
    class func getGoalDocument() -> String {
        return getStringValue(keyName: "goalDocument")
    }
    
    class func setGoalDocument(id: String) {
        putStringValue(id, keyName: "goalDocument")
    }
    
    // goalDocumentId
    class func getCommentDocument() -> String {
        return getStringValue(keyName: "commentDocument")
    }
    
    class func setCommentDocument(id: String) {
        putStringValue(id, keyName: "commentDocument")
    }
    
    // selectedIndex
    class func getSelected() -> Int {
        return getIntValue(keyName: "index")
    }
    
    class func setSelected(index: Int) {
        putIntValue(index, keyName: "index")
    }
}

extension AppUserDefaults {
    private class func getStringValue(keyName: String) -> String {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.string(forKey: keyName) ?? ""
    }
    
    private class func putStringValue(_ value: String, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: keyName)
        userDefaults.synchronize()
    }
    
    private class func getIntValue(keyName: String) -> Int {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: keyName)
    }
    
    private class func putIntValue(_ value: Int, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
        userDefaults.synchronize()
    }
    
    private class func getBoolValue(keyName: String) -> Bool {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: keyName)
    }
    
    private class func putBoolValue(_ value: Bool, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
        userDefaults.synchronize()
    }
}
