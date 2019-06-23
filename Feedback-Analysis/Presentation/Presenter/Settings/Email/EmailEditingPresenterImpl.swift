import Foundation
import RxSwift
import RxCocoa

class EmailEditingPresenterImpl: EmailEditingPresenter {
    
    var view: EmailEditingPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var useCase: SettingsUseCase!
    
    init(useCase: SettingsUseCase) {
        self.useCase = useCase
    }
    
    func update(with email: String) {
        view.updateLoading(true)
        useCase.update(with: email)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.showSuccess(message: "メールアドレスを変更しました")
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}
