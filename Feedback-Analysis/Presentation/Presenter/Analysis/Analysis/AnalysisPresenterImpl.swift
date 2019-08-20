import Foundation
import RxSwift
import RxCocoa

class AnalysisPresenterImpl: NSObject, AnalysisPresenter {
    
    var startPoint: CGPoint?
    
    var view: AnalysisPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: TimelineUseCase
    
    init(useCase: TimelineUseCase) {
        self.useCase = useCase
    }
    
    func post(documentRef: FirebaseDocumentRef, fields: CompletePost) {
        print("hoge")
    }
}

extension AnalysisPresenterImpl: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        view.didSelectSegment(with: index)
    }
}
