import Foundation
import RxSwift
import RxCocoa
import Charts

class AnalysisResultPresenterImpl: NSObject, AnalysisResultPresenter {
    
    var completes: [Complete] = [Complete]()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    var tableData = [(String?, Int)]()
    
    var view: AnalysisResultPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: TimelineUseCase
    
    init(useCase: TimelineUseCase) {
        self.useCase = useCase
    }
    
    func fetch(queryRef: FirebaseQueryRef) {
        useCase.fetchCompletes(queryRef: queryRef)
            .do(onSuccess: { [unowned self] completes in
                let strengthsTuple = MultipleCounting.countMultipleItem(completes.compactMap { $0.strength })
                self.completes = completes
                self.tableData = strengthsTuple.compactMap { ($0.0 as? String, $0.1) }
                self.numberOfDownloadsDataEntries = strengthsTuple.compactMap {
                    PieChartDataEntry(value: Double($0.1), label: $0.0 as? String)
                }
            }).subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    self.view.didFetch(completes: response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
}

extension AnalysisResultPresenterImpl: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
