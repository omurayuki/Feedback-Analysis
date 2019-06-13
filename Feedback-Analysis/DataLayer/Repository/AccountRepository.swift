import Foundation
import RxSwift

protocol AccountRepository {
    func signup(email: String, pass: String) -> Single<AccountEntity>
    func login(email: String, pass: String) -> Single<AccountEntity>
    func reissuePassword(email: String) -> Single<()>
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()>
}

struct AccountRepositoryImpl: AccountRepository {
    
    static let shared = AccountRepositoryImpl()
    
    private let dataStore = AccountDataStoreFactory.createAccountDataStore()
    
    func signup(email: String, pass: String) -> Single<AccountEntity> {
        return dataStore.signup(email: email, pass: pass)
    }
    
    func login(email: String, pass: String) -> Single<AccountEntity> {
        return dataStore.login(email: email, pass: pass)
    }
    
    func reissuePassword(email: String) -> Single<()> {
        return dataStore.reissuePassword(email: email)
    }
    
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()> {
        return dataStore.setData(documentRef: documentRef, fields: fields)
    }
}
