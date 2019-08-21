import Foundation
import UIKit
import RxSwift
import RxCocoa

final class CategorizedViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<CompleteCell, Complete>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: CompleteCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, item, indexPath) in
            cell.content = item
        })
    }()
    
    var ui: CategorizedUI!
    
    var routing: CategorizedRouting!
    
    var presenter: CategorizedPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {}
    }
    
    func inject(ui: CategorizedUI,
                presenter: CategorizedPresenter,
                routing: CategorizedRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension CategorizedViewController {
    
    func recieve(complete: [Complete]) {
        dataSource.listItems = complete
    }
}

extension CategorizedViewController: CategorizedPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
