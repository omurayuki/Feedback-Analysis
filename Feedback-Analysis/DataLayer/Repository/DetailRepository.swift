import Foundation
import RxSwift

protocol DetailRepository {
    func fetch() -> Single<AccountEntity>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func getOtherPersonAuthorFromTimelineToken() -> Single<String>
    func getOtherPersonAuthorFromCommentToken() -> Single<String>
    func set(document id: String) -> Single<()>
    func set(otherPersonAuthorTokenFromTimeline token: String) -> Single<()>
    func set(otherPersonAuthorTokenFromComment token: String) -> Single<()>
    func set(comment id: String) -> Single<()>
    func getDocumentId() -> Single<String>
    func getDocumentIds() -> Single<(documentId: String, commentId: String)>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
    func setGoalsAuthorTokens(_ values: [String]) -> Single<()>
    func getGoalsAuthorTokens() -> Single<[String]>
    func setCompleteAuthorTokens(_ values: [String]) -> Single<()>
    func getCompleteAuthorTokens() -> Single<[String]>
    func setFollowAuthorTokens(_ values: [String]) -> Single<()>
    func getFollowAuthorTokens() -> Single<[String]>
}

struct DetailRepositoryImpl: DetailRepository {
    
    static let shared = DetailRepositoryImpl()

    func fetch() -> Single<AccountEntity> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.fetch()
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.update(to: documentRef, value: value)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.create(documentRef: documentRef, value: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.delete(documentRef: documentRef)
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.post(to: documentRef, comment: comment)
    }
    
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.post(to: documentRef, reply: reply)
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[CommentEntity]> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.get(from: queryRef)
    }
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[ReplyEntity]> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.get(from: queryRef)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        let dataStore = DetailDataStoreFactory.createDetailRemoteDataStore()
        return dataStore.get(documentRef: documentRef)
    }
    
    func getOtherPersonAuthorFromTimelineToken() -> Single<String> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.getOtherPersonAuthorFromTimelineToken()
    }
    
    func getOtherPersonAuthorFromCommentToken() -> Single<String> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.getOtherPersonAuthorFromCommentToken()
    }
    
    func set(document id: String) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.set(document: id)
    }
    
    func set(otherPersonAuthorTokenFromTimeline token: String) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.set(otherPersonAuthorFromTimelineToken: token)
    }
    
    func set(otherPersonAuthorTokenFromComment token: String) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.set(otherPersonAuthorFromCommentToken: token)
    }
    
    func set(comment id: String) -> Single<()> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.set(comment: id)
    }
    
    func getDocumentId() -> Single<String> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.getDocumentId()
    }
    
    func getDocumentIds() -> Single<(documentId: String, commentId: String)> {
        let dataStore = DetailDataStoreFactory.createDetailLocalDataStore()
        return dataStore.getDocumentIds()
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
}
