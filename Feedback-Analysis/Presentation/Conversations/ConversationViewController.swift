import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ConversationViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<ConversationCell, Conversation>

    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: ConversationCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, item, indexPath) in
            cell.content = item
        })
    }()
    
    var ui: ConversationUI!
    
    var routing: ConversationRouting!
    
    var presenter: ConversationPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {}
    }
    
    func inject(ui: ConversationUI,
                presenter: ConversationPresenter,
                routing: ConversationRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.routing = routing
        self.presenter = presenter
        self.disposeBag = disposeBag
        
        self.presenter.fetchConversations(queryRef: .conversationsRef)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension ConversationViewController: ConversationPresenterView {
    
    func didFetch(conversation: [Conversation]) {
        dataSource.listItems = []
        dataSource.listItems += conversation
        ui.tableView.reloadData()
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
        let conversation = dataSource.listItems[indexPath.row]
        routing.showMessagePage(conversation: conversation)
        presenter.markAsRead(conversation: conversation) {
            self.ui.tableView.reloadData()
        }
    }
}
