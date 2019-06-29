import Foundation
import RxSwift

protocol GoalRepository {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
}

struct GoalRepositoryImpl: GoalRepository {
    
    static let shared = GoalRepositoryImpl()
    
    private let dataStore = GoalDataStoreFactory.createGoalDataStore()
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return dataStore.post(to: documentRef, fields: fields)
    }
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        return dataStore.fetch(from: queryRef)
    }
}
