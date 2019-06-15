import Foundation
import RxSwift

protocol EditUseCase {
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()>
}

struct EditUseCaseImpl: EditUseCase {
    
    private(set) var repository: MypageRepository
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        return repository.update(to: documentRef, user: user)
    }
}
