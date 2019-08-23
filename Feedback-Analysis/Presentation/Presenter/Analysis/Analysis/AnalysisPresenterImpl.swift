import Foundation
import RxSwift
import RxCocoa

class AnalysisPresenterImpl: NSObject, AnalysisPresenter {
    
    var startPoint: CGPoint?
    
    var view: AnalysisPresenterView!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: TimelineUseCase
    
    init(useCase: TimelineUseCase) {
        self.useCase = useCase
    }
    
    func post(documentRef: FirebaseDocumentRef, fields: CompletePost) {
        view.updateLoading(true)
        useCase.post(documentRef: documentRef, fields: fields)
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.updateLoading(false)
                    self.view.didPostSuccess()
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
}

extension AnalysisPresenterImpl: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        view.didSelectSegment(with: index)
    }
}
