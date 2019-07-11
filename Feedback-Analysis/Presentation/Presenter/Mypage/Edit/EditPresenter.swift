import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol EditPresenter: Presenter {
    var view: EditPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update)
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef)
    func getUser()
    func getAuthorToken(completion: @escaping (String) -> Void)
}

protocol EditPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: EditUI,
                presenter: EditPresenter,
                routing: EditRouting,
                disposeBag: DisposeBag,
                imagePicker: ImagePicker)
    func showError(message: String)
    func didGetUserData(user: User)
    func didUploadImage(userImage: String)
    func didEditUserData()
    func updateLoading(_ isLoading: Bool)
}
