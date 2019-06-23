import Foundation
import UIKit
import RxSwift
import RxCocoa

class RemindPresenterImpl: RemindPresenter {
    var view: RemindPresenterView!
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var useCase: RemindUseCase
    
    init(useCase: RemindUseCase) {
        self.useCase = useCase
    }
    
    func reissuePassword(email: String) {
        view.updateLoading(true)
        useCase.reissuePassword(email: email)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.didSubmitSuccess()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
