import UIKit

protocol ConversationUI: UI {
    var tableView: UITableView { get }
    
    func setup()
}

final class ConversationUIImpl: ConversationUI {
    
    weak var viewController: UIViewController?
    
    private(set) var tableView: UITableView = {
        let table = UITableView.Builder()
            .backgroundImage(#imageLiteral(resourceName: "logo"))
            .backgroundAlpha(0.1)
            .contentMode(.scaleAspectFit)
            .isUserInteractionEnabled(true)
            .build()
        table.register(ConversationCell.self, forCellReuseIdentifier: String(describing: ConversationCell.self))
        return table
    }()
}

extension ConversationUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.title = "Messsage"
        vc.clearNavBar()
        
        vc.view.addSubview(tableView)
        
        tableView.anchor()
            .edgesToSuperview()
            .activate()
    }
}
