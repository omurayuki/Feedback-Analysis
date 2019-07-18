import Foundation
import RxSwift

protocol OtherPersonPageUseCase {
    func fetch(to: FirebaseDocumentRef) -> Single<User>
    func getAuthorToken() -> Single<String>
}

struct OtherPersonPageUseCaseImpl: OtherPersonPageUseCase {
    
    private(set) var repository: OtherPersonPageRepository
    
    init(repository: OtherPersonPageRepository) {
        self.repository = repository
    }
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<User> {
        return repository
            .fetch(to: documentRef)
            .map { UserTranslator().translate($0) }
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
}
