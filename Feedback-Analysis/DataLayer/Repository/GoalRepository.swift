import Foundation
import RxSwift

protocol GoalRepository {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
}

struct GoalRepositoryImpl: GoalRepository {
    
    static let shared = GoalRepositoryImpl()
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.post(to: documentRef, fields: fields)
    }
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.update(to: documentRef, fields: fields)
    }
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.fetch(from: queryRef)
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.update(to: documentRef, value: value)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.get(documentRef: documentRef)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.create(documentRef: documentRef, value: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.delete(documentRef: documentRef)
    }
    
    func setSelected(index: Int) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.setSelected(index: index)
    }
    
    func getSelected() -> Single<Int> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.getSelected()
    }
    
    func getAuthorToken() -> Single<String> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.getAuthorToken()
    }
}
