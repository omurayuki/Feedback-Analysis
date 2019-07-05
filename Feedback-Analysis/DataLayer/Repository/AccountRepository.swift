import Foundation
import RxSwift

protocol AccountRepository {
    func signup(email: String, pass: String) -> Single<AccountEntity>
    func login(email: String, pass: String) -> Single<AccountEntity>
    func reissuePassword(email: String) -> Single<()>
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()>
    func logout() -> Single<()>
    func update(with email: String) -> Single<()>
    func update(with email: String, oldPass: String, newPass: String) -> Single<()>
}

struct AccountRepositoryImpl: AccountRepository {
    
    static let shared = AccountRepositoryImpl()
    
    func signup(email: String, pass: String) -> Single<AccountEntity> {
        let dataStore = AccountDataStoreFactory.createAccountRemoteDataStore()
        return dataStore.signup(email: email, pass: pass).do(onSuccess: { account in
            AppUserDefaults.setAuthToken(token: account.authToken)
            AppUserDefaults.setAccountEmail(email: account.email)
        })
    }
    
    func login(email: String, pass: String) -> Single<AccountEntity> {
        let dataStore = AccountDataStoreFactory.createAccountRemoteDataStore()
        return dataStore.login(email: email, pass: pass).do(onSuccess: { account in
            AppUserDefaults.setAuthToken(token: account.authToken)
            AppUserDefaults.setAccountEmail(email: account.email)
        })
    }
    
    func reissuePassword(email: String) -> Single<()> {
        let dataStore = AccountDataStoreFactory.createAccountRemoteDataStore()
        return dataStore.reissuePassword(email: email)
    }
    
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()> {
        let dataStore = AccountDataStoreFactory.createAccountRemoteDataStore()
        return dataStore.setData(documentRef: documentRef, fields: fields)
    }
    
    func logout() -> Single<()> {
        let dataStore = AccountDataStoreFactory.createAccountRemoteDataStore()
        return dataStore.logout()
    }
    
    func update(with email: String) -> Single<()> {
        let dataStore = AccountDataStoreFactory.createAccountRemoteDataStore()
        return dataStore.update(with: email).do(onSuccess: { _ in
            AppUserDefaults.setAccountEmail(email: email)
        })
    }
    
    func update(with email: String, oldPass: String, newPass: String) -> Single<()> {
        let dataStore = AccountDataStoreFactory.createAccountRemoteDataStore()
        return dataStore.update(with: email, oldPass: oldPass, newPass: newPass)
    }
}
