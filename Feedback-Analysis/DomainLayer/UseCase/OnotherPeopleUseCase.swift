import Foundation
import RxSwift

protocol OnotherPeopleUseCase {
    func fetch(to: FirebaseDocumentRef) -> Single<User>
    func getAuthorToken() -> Single<String>
}

struct OnotherPeopleUseCaseImpl: OnotherPeopleUseCase {
    
    private(set) var repository: OnotherPeopleRepository
    
    init(repository: OnotherPeopleRepository) {
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
