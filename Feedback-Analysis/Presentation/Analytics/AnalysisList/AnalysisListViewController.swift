import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AnalysisListViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, item, _) in
            cell.content = item
        })
    }()
    
    var ui: AnalysisListUI!
    
    var routing: AnalysisListRouting!
    
    var presenter: AnalysisListPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: AnalysisListUI,
                presenter: AnalysisListPresenter,
                routing: AnalysisListRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .passedGoalRef, loading: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension AnalysisListViewController: AnalysisListPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchGoalData(timeline: [Timeline]) {
        dataSource.listItems = []
        dataSource.listItems += timeline
        ui.tableView.reloadData()
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
        routing.showAnalysisPage(data: dataSource.listItems[indexPath.row])
    }
}
