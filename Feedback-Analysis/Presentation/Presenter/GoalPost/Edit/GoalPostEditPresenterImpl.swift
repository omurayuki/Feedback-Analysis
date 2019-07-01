import Foundation
import UIKit
import RxSwift
import RxCocoa

class GoalPostEditPresenterImpl: NSObject, GoalPostEditPresenter {
    
    var view: GoalPostEditPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var useCase: GoalPostUseCase!
    
    init(useCase: GoalPostUseCase) {
        self.useCase = useCase
    }
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) {
        view.updateLoading(true)
        useCase.post(to: documentRef, fields: fields)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.didPostSuccess()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}

extension GoalPostEditPresenterImpl: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        view.didSelectSegment(with: index)
    }
}
