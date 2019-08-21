import Foundation
import UIKit
import RxSwift
import RxCocoa
import Charts

protocol AnalysisResultPresenter {
    var completes: [Complete] { get set }
    var numberOfDownloadsDataEntries: [PieChartDataEntry] { get set }
    var tableData: [(String?, Int)] { get set }
    var view: AnalysisResultPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(queryRef: FirebaseQueryRef)
}

protocol AnalysisResultPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(presenter: AnalysisResultPresenter,
                routing: AnalysisResultRouting,
                disposeBag: DisposeBag)
    func showError(message: String)
    func didFetch(completes: [Complete])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    func updateLoading(_ isLoading: Bool)
}
