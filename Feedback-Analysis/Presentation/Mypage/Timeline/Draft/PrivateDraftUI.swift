import UIKit

final class PrivateDraftUIImpl: TimelineContentUI {
    
    weak var viewController: UIViewController?
    
    var timeline: UITableView = {
        let table = UITableView()
        table.backgroundView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        table.backgroundView?.alpha = 0.1
        table.backgroundView?.clipsToBounds = true
        table.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFit
        table.tableFooterView = UIView()
        table.backgroundColor = .appMainColor
        table.separatorColor = .appCoolGrey
        table.estimatedRowHeight = 400
        table.rowHeight = UITableView.automaticDimension
        table.register(TimelineCell.self, forCellReuseIdentifier: String(describing: TimelineCell.self))
        return table
    }()
}

extension PrivateDraftUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.clearNavBar()
        
        vc.view.addSubview(timeline)
        
        timeline.anchor()
            .edgesToSuperview()
            .activate()
    }
}
