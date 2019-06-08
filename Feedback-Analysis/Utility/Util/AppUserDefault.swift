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
    
    private class func getIntValue(keyName: String, defValue: Int = 0) -> Int {
        let userDefaults: UserDefaults = UserDefaults.standard
        let value = userDefaults.integer(forKey: keyName)
        if (0 != value) {
            return value
        } else {
            return defValue
        }
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
