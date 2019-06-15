import Foundation
import RxSwift

protocol AccountDataStore {
    func signup(email: String, pass: String) -> Single<AccountEntity>
    func login(email: String, pass: String) -> Single<AccountEntity>
    func reissuePassword(email: String) -> Single<()>
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()>
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
    
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: fields)
    }
}

struct AccountDataStoreFactory {
    
    static func createAccountDataStore() -> AccountDataStore {
        return AccountDataStoreImpl()
    }
}
