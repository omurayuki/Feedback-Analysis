import Foundation
import RxSwift

protocol AccountRemoteDataStore {
    func signup(email: String, pass: String) -> Single<AccountEntity>
    func login(email: String, pass: String) -> Single<AccountEntity>
    func reissuePassword(email: String) -> Single<()>
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()>
    func addData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()>
    func logout() -> Single<()>
    func update(with email: String) -> Single<()>
    func update(with email: String, oldPass: String, newPass: String) -> Single<()>
}

struct AccountRemoteDataStoreImpl: AccountRemoteDataStore {
    
    func signup(email: String, pass: String) -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            AccountEntityManager().signup(email: email, pass: pass, completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func login(email: String, pass: String) -> Single<AccountEntity> {
        return Single.create(subscribe: { single -> Disposable in
            AccountEntityManager().login(email: email, pass: pass, completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func reissuePassword(email: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AccountEntityManager().reissuePassword(email: email, completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().setData(documentRef: documentRef, fields: fields, completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func addData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            Provider().update(documentRef: documentRef, fields: fields,
                              completion: { response in
                switch response {
                case .success(_):
                    single(.success(()))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func logout() -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AccountEntityManager().logout(completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func update(with email: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AccountEntityManager().update(with: email, completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
    
    func update(with email: String, oldPass: String, newPass: String) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AccountEntityManager().update(with: email, oldPass: oldPass, newPass: newPass,
                                          completion: { response in
                switch response {
                case .success(let entity):
                    single(.success(entity))
                case .failure(let error):
                    single(.error(FirebaseError.resultError(error)))
                case .unknown:
                    single(.error(FirebaseError.unknown))
                }
            })
            return Disposables.create()
        })
    }
}
