import Foundation
import RxSwift

protocol TimelineRepository {
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
    func setGoalsAuthorTokens(_ values: [String]) -> Single<()>
    func getGoalsAuthorTokens() -> Single<[String]>
    func setCompleteAuthorTokens(_ values: [String]) -> Single<()>
    func getCompleteAuthorTokens() -> Single<[String]>
    func setFollowAuthorTokens(_ values: [String]) -> Single<()>
    func getFollowAuthorTokens() -> Single<[String]>
    func fetchCompletes(queryRef: FirebaseQueryRef) -> Single<[CompleteEntity]>
    func post(documentRef: FirebaseDocumentRef, fields: CompletePost) -> Single<()>
}

struct TimelineRepositoryImpl: TimelineRepository {
    
    static let shared = TimelineRepositoryImpl()
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[GoalEntity]> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.fetch(timeline: queryRef)
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
    
    func setGoalsAuthorTokens(_ values: [String]) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.setGoalsAuthorTokens(values)
    }
    
    func getGoalsAuthorTokens() -> Single<[String]> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.getGoalsAuthorTokens()
    }
    
    func setCompleteAuthorTokens(_ values: [String]) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.setCompleteAuthorTokens(values)
    }
    
    func getCompleteAuthorTokens() -> Single<[String]> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.getCompleteAuthorTokens()
    }
    
    func setFollowAuthorTokens(_ values: [String]) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.setFollowAuthorTokens(values)
    }
    
    func getFollowAuthorTokens() -> Single<[String]> {
        let dataStore = GoalDataStoreFactory.createGoalLocalDataStore()
        return dataStore.getFollowAuthorTokens()
    }
    
    func fetchCompletes(queryRef: FirebaseQueryRef) -> Single<[CompleteEntity]> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.fetchCompletes(queryRef: queryRef)
    }
    
    func post(documentRef: FirebaseDocumentRef, fields: CompletePost) -> Single<()> {
        let dataStore = GoalDataStoreFactory.createGoalRemoteDataStore()
        return dataStore.post(documentRef: documentRef, fields: fields)
    }
}
