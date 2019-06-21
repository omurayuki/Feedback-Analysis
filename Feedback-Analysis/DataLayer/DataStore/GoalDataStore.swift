import Foundation
import RxSwift

protocol GoalDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
}

struct GoalDataStoreImpl: GoalDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: fields.encode())
    }
}

struct GoalDataStoreFactory {
    
    static func createGoalDataStore() -> GoalDataStore {
        return GoalDataStoreImpl()
    }
}
