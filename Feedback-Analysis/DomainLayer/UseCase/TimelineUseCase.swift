import Foundation
import RxSwift

protocol TimelineUseCase {
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[Timeline]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
    func setGoalsAuthorTokens(_ values: [String]) -> Single<()>
    func getGoalsAuthorTokens(_ index: Int) -> Single<String>
    func setCompleteAuthorTokens(_ values: [String]) -> Single<()>
    func getCompleteAuthorTokens(_ index: Int) -> Single<String>
    func setFollowAuthorTokens(_ values: [String]) -> Single<()>
    func getFollowAuthorTokens(_ index: Int) -> Single<String>
}

struct TimelineUseCaseImpl: TimelineUseCase {
    
    private(set) var repository: TimelineRepository
    
    init(repository: TimelineRepository) {
        self.repository = repository
    }
    
    func fetch(from queryRef: FirebaseQueryRef) -> Observable<[Timeline]> {
        return repository.fetch(from: queryRef).map { GoalsTranslator().translate($0) }
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return repository.update(to: documentRef, value: value)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return repository.get(documentRef: documentRef)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return repository.create(documentRef: documentRef, value: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return repository.delete(documentRef: documentRef)
    }
    
    func setSelected(index: Int) -> Single<()> {
        return repository.setSelected(index: index)
    }
    
    func getSelected() -> Single<Int> {
        return repository.getSelected()
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
    
    func setGoalsAuthorTokens(_ values: [String]) -> Single<()> {
        return repository.setGoalsAuthorTokens(values)
    }
    
    func getGoalsAuthorTokens(_ index: Int) -> Single<String> {
        return repository.getGoalsAuthorTokens().map { AuthorTokensTranslator().translate($0, index) }
    }
    
    func setCompleteAuthorTokens(_ values: [String]) -> Single<()> {
        return repository.setCompleteAuthorTokens(values)
    }
    
    func getCompleteAuthorTokens(_ index: Int) -> Single<String> {
        return repository.getCompleteAuthorTokens().map { AuthorTokensTranslator().translate($0, index) }
    }
    
    func setFollowAuthorTokens(_ values: [String]) -> Single<()> {
        return repository.setFollowAuthorTokens(values)
    }
    
    func getFollowAuthorTokens(_ index: Int) -> Single<String> {
        return repository.getFollowAuthorTokens().map { AuthorTokensTranslator().translate($0, index) }
    }
}
