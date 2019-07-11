import Foundation
import RxSwift

protocol AccountRemoteDataStore {
    func signup(email: String, pass: String) -> Single<AccountEntity>
    func login(email: String, pass: String) -> Single<AccountEntity>
    func reissuePassword(email: String) -> Single<()>
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()>
    func logout() -> Single<()>
    func update(with email: String) -> Single<()>
    func update(with email: String, oldPass: String, newPass: String) -> Single<()>
}

struct AccountRemoteDataStoreImpl: AccountRemoteDataStore {
    
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
    
    func logout() -> Single<()> {
        return Provider().logout()
    }
    
    func update(with email: String) -> Single<()> {
        return Provider().update(with: email)
    }
    
    func update(with email: String, oldPass: String, newPass: String) -> Single<()> {
        return Provider().update(with: email, oldPass: oldPass, newPass: newPass)
    }
}
