import Foundation
import RxSwift

protocol GoalRepository {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
}

struct GoalRepositoryImpl: GoalRepository {
    
    static let shared = GoalRepositoryImpl()
    
    private let dataStore = GoalDataStoreFactory.createGoalDataStore()
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return dataStore.post(to: documentRef, fields: fields)
    }
}
