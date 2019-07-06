import Foundation
import RxSwift
import RxCocoa
import GrowingTextView

class DetailPresenterImpl: NSObject, DetailPresenter {
    var view: DetailPresenterView!
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: DetailUseCase
    
    init(useCase: DetailUseCase) {
        self.useCase = useCase
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
        view.updateLoading(true)
        useCase.get(from: queryRef)
            .subscribe(onNext: { [unowned self] result in
                self.view.didFetchComments(comments: result)
                self.view.updateLoading(false)
            }, onError: { error in
                self.view.updateLoading(false)
                self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
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
}
