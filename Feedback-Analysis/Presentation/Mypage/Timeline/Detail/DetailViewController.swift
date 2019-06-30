import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    typealias DetailDataSource = TableViewDataSource<TimelineCell, Timeline>
    typealias CommentDataStore = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) var detailDataSource: DetailDataSource = {
        return DetailDataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          cellConfigurationHandler: { (cell, item, _) in
                            cell.content = item
        })
    }()
    
    private(set) var commentDataSource: CommentDataStore = {
        return CommentDataStore(cellReuseIdentifier: String(describing: TimelineCell.self),
                                listItems: [],
                                cellConfigurationHandler: { (cell, item, _) in
                                    cell.content = item
        })
    }()
    
    var ui: DetailUI!
    
    var routing: DetailRouting!
    
    var presenter: DetailPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            
        }
    }
    
    func inject(ui: DetailUI, presenter: DetailPresenter, routing: DetailRouting, disposeBag: DisposeBag) {
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

extension DetailViewController {
    
    func recieve(data timeline: Timeline, height: CGFloat) {
        ui.determineHeight(height: height)
        detailDataSource.listItems.append(timeline)
        ui.detail.reloadData()
    }
}

extension DetailViewController: DetailPresenterView {}
