import UIKit

protocol CategorizedUI: UI {
    var tableView: UITableView { get set }
    
    func setup()
}

final class CategorizedUIImpl: CategorizedUI {
    
    var viewController: UIViewController?
    
    var tableView: UITableView = {
        let table = UITableView.Builder()
            .backgroundImage(#imageLiteral(resourceName: "logo"))
            .backgroundAlpha(0.1)
            .contentMode(.scaleAspectFit)
            .estimatedRowHeight(400)
            .build()
        table.register(CompleteCell.self, forCellReuseIdentifier: String(describing: CompleteCell.self))
        return table
    }()
}

extension CategorizedUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.clearNavBar()
        
        vc.view.addSubview(tableView)
        
        tableView.anchor()
            .edgesToSuperview()
            .activate()
    }
}
