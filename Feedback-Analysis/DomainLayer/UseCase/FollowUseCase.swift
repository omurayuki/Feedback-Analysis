import Foundation
import RxSwift

protocol FollowUseCase {
}

struct FollowUseCaseImpl: FollowUseCase {
    
    private(set) var repository: FollowRepository
    
    init(repository: FollowRepository) {
        self.repository = repository
    }
}
