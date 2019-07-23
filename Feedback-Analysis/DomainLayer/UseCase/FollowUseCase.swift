import Foundation
import RxSwift

protocol FollowUseCase {
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[User]>
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[User]>
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken(_ index: Int) -> Single<String>
}

struct FollowUseCaseImpl: FollowUseCase {
    
    private(set) var repository: FollowRepository
    
    init(repository: FollowRepository) {
        self.repository = repository
    }
    
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[User]> {
        return repository
            .fetchFollower(from: queryRef)
            .map { UsersTranslator().translate($0) }
    }
    
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[User]> {
        return repository
            .fetchFollowee(from: queryRef)
            .map { UsersTranslator().translate($0) }
    }
    
    func setAuthorTokens(_ values: [String]) -> Single<()> {
        return repository.setAuthorTokens(values)
    }
    
    func getAuthorToken(_ index: Int) -> Single<String> {
        return repository.getAuthorToken(index)
    }
}
