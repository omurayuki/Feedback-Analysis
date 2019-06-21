import Foundation
import RxSwift

protocol GoalPostUseCase {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
}

struct GoalPostUseCaseImpl: GoalPostUseCase {
    
    private(set) var repository: GoalRepository
    
    init(repository: GoalRepository) {
        self.repository = repository
    }
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return repository.post(to: documentRef, fields: fields)
    }
}
