import Foundation
import RxSwift

protocol GoalPostUseCase {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from collectionRef: FirebaseCollectionRef) -> Observable<[Timeline]>
}

struct GoalPostUseCaseImpl: GoalPostUseCase {
    
    private(set) var repository: GoalRepository
    
    init(repository: GoalRepository) {
        self.repository = repository
    }
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return repository.post(to: documentRef, fields: fields)
    }
    
    func fetch(from collectionRef: FirebaseCollectionRef) -> Observable<[Timeline]> {
        return repository.fetch(from: collectionRef).map { GoalsTranslater().translate($0) }
    }
}
