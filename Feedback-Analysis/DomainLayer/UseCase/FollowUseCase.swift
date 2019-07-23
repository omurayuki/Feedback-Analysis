import Foundation
import RxSwift

protocol FollowUseCase {
    func fetchFollower(from queryRef: FirebaseQueryRef) -> Single<[User]>
    func fetchFollowee(from queryRef: FirebaseQueryRef) -> Single<[User]>
    func setFolloweeTokens(_ values: [String]) -> Single<()>
    func setFollowerTokens(_ values: [String]) -> Single<()>
    func getFolloweeToken(_ index: Int) -> Single<String>
    func getFollowerToken(_ index: Int) -> Single<String>
    func setObjectToken(_ value: String) -> Single<()>
    func getObjectToken() -> Single<String>
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
    
    func setFolloweeTokens(_ values: [String]) -> Single<()> {
        return repository.setFolloweeTokens(values)
    }
    
    func setFollowerTokens(_ values: [String]) -> Single<()> {
        return repository.setFollowerTokens(values)
    }
    
    func getFolloweeToken(_ index: Int) -> Single<String> {
        return repository.getFolloweeToken()
            .map { AuthorTokensTranslator().translate($0, index) }
    }
    
    func getFollowerToken(_ index: Int) -> Single<String> {
        return repository.getFollowerToken()
            .map { AuthorTokensTranslator().translate($0, index) }
    }
    
    func setObjectToken(_ value: String) -> Single<()> {
        return repository.setObjectToken(value)
    }
    
    func getObjectToken() -> Single<String> {
        return repository.getObjectToken()
    }
}
