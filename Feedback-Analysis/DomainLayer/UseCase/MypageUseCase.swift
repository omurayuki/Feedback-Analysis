import Foundation
import RxSwift

protocol MypageUseCase {
    func fetch(to: FirebaseDocumentRef) -> Single<User>
    func set(user: [User]) -> Single<()>
    func getAuthorToken() -> Single<String>
}

struct MypageUseCaseImpl: MypageUseCase {
    
    private(set) var repository: MypageRepository
    
    init(repository: MypageRepository) {
        self.repository = repository
    }
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<User> {
        return repository
            .fetch(to: documentRef)
            .map { UserTranslator().translate($0) }
    }
    
    func set(user: [User]) -> Single<()> {
        return repository.set(user: user)
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
}
