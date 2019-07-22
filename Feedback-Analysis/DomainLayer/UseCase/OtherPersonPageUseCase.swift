import Foundation
import RxSwift

protocol OtherPersonPageUseCase {
    func fetch(to: FirebaseDocumentRef) -> Single<User>
    func getAuthorToken() -> Single<String>
    func follow(documentRef: FirebaseDocumentRef) -> Single<()>
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()>
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func setObjectToken(_ token: String) -> Single<()>
    func getBothToken() -> Single<(String, String)>
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
    
    func follow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return repository.follow(documentRef: documentRef)
    }
    
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()> {
        return repository.unFollow(documentRef: documentRef)
    }
    
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return repository.checkFollowing(documentRef: documentRef)
    }
    
    func setObjectToken(_ token: String) -> Single<()> {
        return repository.setObjectToken(token)
    }
    
    func getBothToken() -> Single<(String, String)> {
        return repository.getBothToken()
    }
}
