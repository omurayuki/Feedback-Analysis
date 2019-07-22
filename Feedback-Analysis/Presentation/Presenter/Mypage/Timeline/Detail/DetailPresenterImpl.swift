import Foundation
import RxSwift
import RxCocoa
import GrowingTextView

class DetailPresenterImpl: NSObject, DetailPresenter {
    var view: DetailPresenterView!
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var keyboardNotifier: KeyboardNotifier! = KeyboardNotifier()
    
    private var useCase: DetailUseCase
    
    init(useCase: DetailUseCase) {
        self.useCase = useCase
        super.init()
        listenKeyboard(keyboardNotifier: keyboardNotifier)
    }
    
    func fetch() {
        view.updateLoading(true)
        useCase.fetch()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    self.view.updateLoading(false)
                    self.view.didFetchUser(data: response)
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) {
        useCase.update(to: documentRef, value: value)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    break
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) {
        useCase.create(documentRef: documentRef, value: value)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.didCreateLikeRef()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func delete(documentRef: FirebaseDocumentRef) {
        useCase.delete(documentRef: documentRef)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.didDeleteLikeRef()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: CommentPost) {
        view.updateLoading(true)
        useCase.post(to: documentRef, comment: comment)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.didPostSuccess()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func get(from queryRef: FirebaseQueryRef) {
        useCase.get(comments: queryRef)
            .subscribe(onNext: { [unowned self] result in
                self.view.didFetchComments(comments: result)
                }, onError: { error in
                    self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
    }
    
    func get(documentRef: FirebaseDocumentRef) {
        useCase.get(documentRef: documentRef)
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    self.view.didCheckIfYouLiked(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getOtherPersonAuthorToken(completion: @escaping (String) -> Void) {
        useCase.getOtherPersonAuthorFromTimelineToken()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func set(document id: String, completion: @escaping () -> Void) {
        useCase.set(document: id)
            .subscribe { result in
                switch result {
                case .success(_):
                    completion()
                case .error(_):
                    break
                }
            }.disposed(by: view.disposeBag)
    }
    
    func set(otherPersonAuthorToken token: String) {
        useCase.set(otherPersonAuthorTokenFromTimeline: token)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    break
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getDocumentId(completion: @escaping (String) -> Void) {
        useCase.getDocumentId()
            .subscribe { result in
                switch result {
                case .success(let documentId):
                    completion(documentId)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setSelected(index: Int) {
        useCase.setSelected(index: index)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getSelected(completion: @escaping (Int) -> Void) {
        useCase.getSelected()
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(_):
                    return
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
    
    func setAuthorTokens(_ values: [String]) {
        useCase.setGoalsAuthorTokens(values)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getAuthorToken(_ index: Int, completion: @escaping (String) -> Void) {
        useCase.getGoalsAuthorTokens(index)
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
}

extension DetailPresenterImpl: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.SpringAnimator(duration: 0.3, damping: 0.7, velocity: 0.7, options: [.curveLinear])
            .animations {
                self.view.didChangeTextHeight()
            }.animate()
    }
}

extension DetailPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(tableView: tableView, indexPath: indexPath)
    }
}

extension DetailPresenterImpl: KeyboardListener {
    
    func keyboardPresent(_ height: CGFloat) {
        view.keyboardPresent(height)
    }
    
    func keyboardDismiss(_ height: CGFloat) {
        view.keyboardDismiss(height)
    }
}
