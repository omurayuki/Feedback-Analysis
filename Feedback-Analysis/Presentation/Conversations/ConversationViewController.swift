import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
//    typealias DataSource = TableViewDataSource<ConversationCell, Timeline>
//
//    private(set) lazy var dataSource: DataSource = {
//        return DataSource(cellReuseIdentifier: String(describing: ConversationCell.self),
//                          listItems: [],
//                          isSkelton: false,
//                          cellConfigurationHandler: { (cell, item, indexPath) in
//        })
//    }()
    
    private lazy var ui: ConversationUI = {
        let ui = ConversationUIImpl()
        ui.viewController = self
        return ui
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.tableView.delegate = self
        ui.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationCell.self), for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
