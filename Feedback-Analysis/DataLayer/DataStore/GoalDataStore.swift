import Foundation
import RxSwift

protocol GoalDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
}

struct GoalDataStoreImpl: GoalDataStore {
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: fields.encode())
    }
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Provider().update(documentRef: documentRef, fields: fields.encode())
    }
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        return Provider().observeQuery(queryRef: queryRef)
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return Provider().update(documentRef: documentRef, fields: value)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return Provider().get(documentRef: documentRef)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return Provider().delete(documentRef: documentRef)
    }
    
    func setSelected(index: Int) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setSelected(index: index)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getSelected() -> Single<Int> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getSelected()))
            return Disposables.create()
        })
    }
}

struct GoalDataStoreFactory {
    
    static func createGoalDataStore() -> GoalDataStore {
        return GoalDataStoreImpl()
    }
}
