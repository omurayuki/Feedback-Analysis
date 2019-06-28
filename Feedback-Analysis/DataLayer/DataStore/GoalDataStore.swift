import Foundation
import RxSwift

protocol GoalDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from collectionRef: FirebaseCollectionRef) -> Observable<[GoalEntity]>
}

struct GoalDataStoreImpl: GoalDataStore {
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: fields.encode())
    }
    
    func fetch(from collectionRef: FirebaseCollectionRef) -> Observable<[GoalEntity]> {
        return Provider().observeTimeline(collectionRef: collectionRef)
    }
}

struct GoalDataStoreFactory {
    
    static func createGoalDataStore() -> GoalDataStore {
        return GoalDataStoreImpl()
    }
}
