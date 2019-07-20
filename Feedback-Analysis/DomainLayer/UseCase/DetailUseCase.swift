import Foundation
import RxSwift

protocol DetailUseCase {
    func fetch() -> Single<Account>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(comments queryRef: FirebaseQueryRef) -> Observable<[Comment]>
    func get(replies queryRef: FirebaseQueryRef) -> Observable<[Reply]>
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
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken(_ index: Int) -> Single<String>
}

struct DetailUseCaseImpl: DetailUseCase {
    
    private(set) var repository: DetailRepository
    
    init(repository: DetailRepository) {
        self.repository = repository
    }
    
    func fetch() -> Single<Account> {
        return repository.fetch().map { AccountTranslator().translate($0) }
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return repository.update(to: documentRef, value: value)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        return repository.create(documentRef: documentRef, value: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return repository.delete(documentRef: documentRef)
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()> {
        return repository.post(to: documentRef, comment: comment)
    }
    
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()> {
        return repository.post(to: documentRef, reply: reply)
    }
    
    func get(comments queryRef: FirebaseQueryRef) -> Observable<[Comment]> {
        return repository.get(from: queryRef).map { CommentsTranslator().translate($0) }
    }
    
    func get(replies queryRef: FirebaseQueryRef) -> Observable<[Reply]> {
        return repository.get(from: queryRef).map { RepliesTranslator().translate($0) }
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return repository.get(documentRef: documentRef)
    }
    
    func getOtherPersonAuthorFromTimelineToken() -> Single<String> {
        return repository.getOtherPersonAuthorFromTimelineToken()
    }
    
    func getOtherPersonAuthorFromCommentToken() -> Single<String> {
        return repository.getOtherPersonAuthorFromCommentToken()
    }
    
    func set(document id: String) -> Single<()> {
        return repository.set(document: id)
    }
    
    func set(otherPersonAuthorTokenFromTimeline token: String) -> Single<()> {
        return repository.set(otherPersonAuthorTokenFromTimeline: token)
    }
    
    func set(otherPersonAuthorTokenFromComment token: String) -> Single<()> {
        return repository.set(otherPersonAuthorTokenFromComment: token)
    }
    
    func set(comment id: String) -> Single<()> {
        return repository.set(comment: id)
    }
    
    func getDocumentId() -> Single<String> {
        return repository.getDocumentId()
    }
    
    func getDocumentIds() -> Single<(documentId: String, commentId: String)> {
        return repository.getDocumentIds()
    }
    
    func setSelected(index: Int) -> Single<()> {
        return repository.setSelected(index: index)
    }
    
    func getSelected() -> Single<Int> {
        return repository.getSelected()
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
    
    func setAuthorTokens(_ values: [String]) -> Single<()> {
        return repository.setAuthorTokens(values)
    }
    
    func getAuthorToken(_ index: Int) -> Single<String> {
        return repository.getAuthorToken().map { AuthorTokensTranslator().translate($0, index) }
    }
}
