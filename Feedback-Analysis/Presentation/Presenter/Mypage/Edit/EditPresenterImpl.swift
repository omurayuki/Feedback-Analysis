import Foundation
import RxSwift
import RxCocoa

class EditPresenterImpl: EditPresenter {
    var view: EditPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: EditUseCase
    
    init(useCase: EditUseCase) {
        self.useCase = useCase
    }
    
    func update(to documentRef: FirebaseDocumentRef, user: Update) {
        useCase.update(to: documentRef, user: user)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.didEditUserData()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef) {
        view.updateLoading(true)
        useCase.uploadImage(image, at: storageRef)
            .subscribe { [unowned self] result in
                switch result {
                case .success(let url):
                    self.view.updateLoading(false)
                    self.view.didUploadImage(userImage: url.absoluteString)
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getUser() {
        useCase.getUser()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    guard let user = response.first else { return }
                    self.view.didGetUserData(user: user)
                    return
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getAuthorToken(completion: @escaping (String) -> Void) {
        useCase.getAuthorToken()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
