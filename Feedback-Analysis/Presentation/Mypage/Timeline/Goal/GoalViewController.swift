import Foundation
import UIKit
import RxSwift
import RxCocoa

class GoalViewController: UIViewController {
    
    typealias DataSource = TimelineTableViewDataSource<TimelineCell, Timeline>
    
    private(set) var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          cellConfigurationHandler: { (cell, item, _) in
            cell.content = item
        })
    }()
    
    var ui: GoalUI!
    
    var routing: GoalRouting!
    
    var presenter: GoalPresenter! {
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
    
    func inject(ui: GoalUI, presenter: GoalPresenter, routing: GoalRouting, disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .goalsRef, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension GoalViewController: GoalPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchGoalData(timeline: [Timeline]) {
        dataSource.listItems = []
        dataSource.listItems += timeline
        ui.timeline.reloadData()
    }
    
    func didSelect(row index: Int) {
        print("hoge")
    }
}
