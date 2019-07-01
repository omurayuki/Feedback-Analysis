import Foundation
import RxSwift

protocol DetailUseCase {
    func fetch() -> Single<Account>
    func post(to documentRef: FirebaseDocumentRef, comment: Comment) -> Single<()>
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
    
    func post(to documentRef: FirebaseDocumentRef, comment: Comment) -> Single<()> {
        return repository.post(to: documentRef, comment: comment)
    }
}
