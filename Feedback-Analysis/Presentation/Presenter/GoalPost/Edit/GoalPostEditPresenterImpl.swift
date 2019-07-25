import Foundation
import UIKit
import RxSwift
import RxCocoa

class GoalPostEditPresenterImpl: NSObject, GoalPostEditPresenter {
    
    var startPoint: CGPoint?
    var genres = [String]()
    
    var view: GoalPostEditPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var useCase: GoalPostUseCase!
    
    init(useCase: GoalPostUseCase) {
        self.useCase = useCase
    }
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) {
        view.updateLoading(true)
        useCase.update(to: documentRef, fields: fields)
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
    
    func getGoalDocumentId(completion: @escaping (String) -> Void) {
        useCase.getGoalDocumentId()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setGoalDocumentId(_ value: String) {
        useCase.setGoalDocumentId(value)
            .subscribe {result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
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
