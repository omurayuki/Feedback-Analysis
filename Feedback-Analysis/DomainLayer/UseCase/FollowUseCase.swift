import Foundation
import RxSwift

protocol FollowUseCase {
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[User]>
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken(_ index: Int) -> Single<String>
}

struct FollowUseCaseImpl: FollowUseCase {
    
    private(set) var repository: FollowRepository
    
    init(repository: FollowRepository) {
        self.repository = repository
    }
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[User]> {
        return repository
            .fetch(from: queryRef)
            .map { UsersTranslator().translate($0) }
    }
    
    func setAuthorTokens(_ values: [String]) -> Single<()> {
        return repository.setAuthorTokens(values)
    }
    
    func getAuthorToken(_ index: Int) -> Single<String> {
        return repository.getAuthorToken(index)
    }
}
