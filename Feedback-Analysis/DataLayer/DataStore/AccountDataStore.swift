import Foundation
import RxSwift
import FirebaseAuth

protocol AccountDataStore {
    func signup(email: String, pass: String) -> Single<AccountEntity>
    func login(email: String, pass: String) -> Single<AccountEntity>
    func reissuePassword(email: String) -> Single<()>
}

struct AccountDataStoreImpl: AccountDataStore {
    func signup(email: String, pass: String) -> Single<AccountEntity> {
        return Provider().signup(email: email, pass: pass)
    }
    
    func login(email: String, pass: String) -> Single<AccountEntity> {
        return Provider().login(email: email, pass: pass)
    }
    
    func reissuePassword(email: String) -> Single<()> {
        return Provider().reissuePassword(email: email)
    }
}

struct AccountDataStoreFactory {
    
    static func createAccountDataStore() -> AccountDataStore {
        return AccountDataStoreImpl()
    }
}
