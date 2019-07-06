import Foundation
import RxSwift

protocol DetailUseCase {
    func fetch() -> Single<Account>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) -> Single<()>
    func get(comments queryRef: FirebaseQueryRef) -> Observable<[Comment]>
    func get(replies queryRef: FirebaseQueryRef) -> Observable<[Reply]>
    func set(document id: String) -> Single<()>
    func set(comment id: String) -> Single<()>
    func getDocumentId() -> Single<String>
    func getDocumentIds() -> Single<(documentId: String, commentId: String)>
}

struct DetailUseCaseImpl: DetailUseCase {
    
    private(set) var repository: DetailRepository
    
    init(repository: DetailRepository) {
        self.repository = repository
    }
    
    func fetch() -> Single<Account> {
        return repository
            .fetch()
            .map { AccountTranslator().translate($0) }
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
    
    func set(document id: String) -> Single<()> {
        return repository.set(document: id)
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
}
