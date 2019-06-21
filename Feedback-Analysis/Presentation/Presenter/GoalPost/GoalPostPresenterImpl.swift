import Foundation
import UIKit
import RxSwift
import RxCocoa

class GoalPostPresenterImpl: NSObject, GoalPostPresenter {
    
    var view: GoalPostPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var useCase: GoalPostUseCase!
    
    init(useCase: GoalPostUseCase) {
        self.useCase = useCase
    }
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) {
        useCase.post(to: documentRef, fields: fields)
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.didPostSuccess()
                case .error(let error):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}

extension GoalPostPresenterImpl: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        view.didSelectSegment(with: index)
    }
}
