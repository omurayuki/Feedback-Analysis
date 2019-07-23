import Foundation
import RxSwift
import RxCocoa

class FollowListPresenterImpl: NSObject, FollowListPresenter {
    
    var view: FollowListPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isFirstLoading: Bool = true
    
    private var useCase: FollowUseCase
    
    init(useCase: FollowUseCase) {
        self.useCase = useCase
    }
    
    func fetch(from queryRef: FirebaseQueryRef, loading: Bool, completion: (() -> Void)?) {
        //// true = followee
        //// false = follower
        switch queryRef.isFollow {
        case true:
            view.updateLoading(loading)
            useCase.fetchFollowee(from: queryRef)
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        self.view.updateLoading(false)
                        self.view.didFetchUsersData(users: response)
                        completion?()
                    case .error(let error):
                        self.view.updateLoading(false)
                        self.view.showError(message: error.localizedDescription)
                    }
                }.disposed(by: view.disposeBag)
        case false:
            view.updateLoading(loading)
            useCase.fetchFollower(from: queryRef)
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        self.view.updateLoading(false)
                        self.view.didFetchUsersData(users: response)
                        completion?()
                    case .error(let error):
                        self.view.updateLoading(false)
                        self.view.showError(message: error.localizedDescription)
                    }
                }.disposed(by: view.disposeBag)
        }
    }
    
    func setFolloweeTokens(_ values: [String]) {
        useCase.setFolloweeTokens(values)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setFollowerTokens(_ values: [String]) {
        useCase.setFollowerTokens(values)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getFolloweeToken(_ index: Int) {
        useCase.getFolloweeToken(index)
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    self.view.didRecieveUserToken(token: response)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getFollowerToken(_ index: Int) {
        useCase.getFollowerToken(index)
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    self.view.didRecieveUserToken(token: response)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setObjectToken(_ value: String) {
        useCase.setObjectToken(value)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getObjectToken(completion: @escaping (String) -> Void) {
        useCase.getObjectToken()
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
