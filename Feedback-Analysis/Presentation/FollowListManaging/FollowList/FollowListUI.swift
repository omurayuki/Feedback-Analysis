import UIKit

protocol FollowListUI: UI {
    var refControl: UIRefreshControl { get }
    var followList: UITableView { get set }
    func setup()
}

final class FollowListUIImpl: FollowListUI {
    
    weak var viewController: UIViewController?
    
    var refControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        return refControl
    }()
    
    var followList: UITableView = {
        let table = UITableView.Builder()
            .backgroundImage(#imageLiteral(resourceName: "logo"))
            .backgroundAlpha(0.1)
            .contentMode(.scaleAspectFit)
            .estimatedRowHeight(400)
            .isUserInteractionEnabled(true)
            .build()
        table.register(FollowListCell.self, forCellReuseIdentifier: String(describing: FollowListCell.self))
        return table
    }()
}

extension FollowListUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.clearNavBar()
        
        vc.view.addSubview(followList)
        followList.addSubview(refControl)
        
        followList.anchor()
            .edgesToSuperview()
            .activate()
    }
}
