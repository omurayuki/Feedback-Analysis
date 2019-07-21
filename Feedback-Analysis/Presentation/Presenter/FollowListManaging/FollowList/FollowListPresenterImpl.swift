import Foundation
import RxSwift
import RxCocoa

class FollowListPresenterImpl: NSObject, FollowListPresenter {
    
    var view: FollowListPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isFiestLoading: Bool = true
    
    private var useCase: FollowUseCase
    
    init(useCase: FollowUseCase) {
        self.useCase = useCase
    }
    
    func fetch(from queryRef: FirebaseQueryRef, loading: Bool, completion: (() -> Void)?) {
        view.updateLoading(loading)
        useCase.fetch(from: queryRef)
            .subscribe(onNext: { [unowned self] result in
                self.view.updateLoading(false)
                self.view.didFetchUsersData(users: result)
                completion?()
                }, onError: { error in
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
    }
    
    func setAuthorTokens(_ values: [String]) {
        useCase.setAuthorTokens(values)
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
        useCase.getAuthorToken(index)
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}

extension FollowListPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
