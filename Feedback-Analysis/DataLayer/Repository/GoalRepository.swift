import Foundation
import RxSwift

protocol GoalRepository {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
}

struct GoalRepositoryImpl: GoalRepository {
    
    static let shared = GoalRepositoryImpl()
    
    private let dataStore = GoalDataStoreFactory.createGoalDataStore()
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return dataStore.post(to: documentRef, fields: fields)
    }
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return dataStore.update(to: documentRef, fields: fields)
    }
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        return dataStore.fetch(from: queryRef)
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return dataStore.update(to: documentRef, value: value)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return dataStore.get(documentRef: documentRef)
    }
}
