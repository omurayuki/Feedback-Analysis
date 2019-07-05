import Foundation
import RxSwift
import RxCocoa

class DraftPresenterImpl: NSObject, DraftPresenter {
    var view: DraftPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: GoalPostUseCase
    
    init(useCase: GoalPostUseCase) {
        self.useCase = useCase
    }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?) {
        view.updateLoading(true)
        useCase.fetch(from: queryRef)
            .subscribe(onNext: { [unowned self] result in
                self.view.updateLoading(false)
                self.view.didFetchGoalData(timeline: result)
            }, onError: { error in
                self.view.updateLoading(false)
                self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
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
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) {
        useCase.create(documentRef: documentRef, value: value)
            .subscribe { result in
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
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.didDeleteLikeRef()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
}

extension DraftPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
