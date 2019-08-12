import Foundation
import RxSwift
import RxCocoa

class AnalysisListPresenterImpl: NSObject, AnalysisListPresenter {
    
    var view: AnalysisListPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isFirstLoading: Bool = true
    
    private var useCase: TimelineUseCase
    
    init(useCase: TimelineUseCase) {
        self.useCase = useCase
    }
    
    func fetch(from queryRef: FirebaseQueryRef, loading: Bool, completion: (() -> Void)?) {
        view.updateLoading(loading)
        useCase.fetch(from: queryRef)
            .subscribe(onNext: { [unowned self] result in
                self.view.updateLoading(false)
                self.view.didFetchGoalData(timeline: result)
                completion?()
                }, onError: { error in
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
    }
}

extension AnalysisListPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
