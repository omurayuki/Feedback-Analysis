import Foundation
import RxSwift

protocol DetailUseCase {
    func fetch() -> Single<Account>
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) -> Single<()>
    func get(from queryRef: FirebaseQueryRef) -> Observable<[Comment]>
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
    
    func get(from queryRef: FirebaseQueryRef) -> Observable<[Comment]> {
        return repository.get(from: queryRef).map { CommentsTranslator().translate($0) }
    }
}
