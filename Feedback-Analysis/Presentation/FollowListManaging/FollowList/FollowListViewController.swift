import Foundation
import UIKit
import RxSwift
import RxCocoa

class FollowListViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<FollowListCell, User>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: FollowListCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, user, _) in
            cell.content = user
        })
    }()
    
    var ui: FollowListUI!
    
    func inject(ui: FollowListUI) {
        self.ui = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}
