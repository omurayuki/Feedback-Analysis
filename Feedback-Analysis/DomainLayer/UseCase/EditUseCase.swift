import Foundation
import RxSwift

protocol EditUseCase {
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()>
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL>
}

struct EditUseCaseImpl: EditUseCase {
    
    private(set) var repository: MypageRepository
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        return repository.update(to: documentRef, user: user)
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        return repository.uploadImage(image, at: storageRef)
    }
}
