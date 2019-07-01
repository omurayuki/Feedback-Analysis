import Foundation
import RxSwift

protocol GoalDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
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
}

struct GoalDataStoreFactory {
    
    static func createGoalDataStore() -> GoalDataStore {
        return GoalDataStoreImpl()
    }
}
