import Foundation
import RxSwift

protocol EditUseCase {
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()>
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL>
    func getUser() -> Single<[User]>
    func getAuthorToken() -> Single<String>
}

struct EditUseCaseImpl: EditUseCase {
    
    private(set) var repository: MypageRepository
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) -> Single<()> {
        return repository.update(to: documentRef, user: user)
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) -> Single<URL> {
        return repository.uploadImage(image, at: storageRef)
    }
    
    func getUser() -> Single<[User]> {
        return repository.getUser().map { UsersTranslator().translate($0) }
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
}
