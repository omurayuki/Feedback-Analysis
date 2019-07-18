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
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken(_ index: Int) -> Single<String>
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
    
    func setAuthorTokens(_ values: [String]) -> Single<()> {
        return repository.setAuthorTokens(values)
    }
    
    func getAuthorToken(_ index: Int) -> Single<String> {
        return repository.getAuthorToken().map { AuthorTokensTranslator().translate($0, index) }
    }
}
