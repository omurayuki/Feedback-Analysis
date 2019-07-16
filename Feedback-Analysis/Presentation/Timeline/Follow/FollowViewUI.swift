import UIKit

final class FollowViewUIImpl: PublicTimelineContentUI {
    
    weak var viewController: UIViewController?
    
    var refControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        return refControl
    }()
    
    var timeline: UITableView = {
        let table = UITableView.Builder()
            .backgroundImage(#imageLiteral(resourceName: "logo"))
            .backgroundAlpha(0.1)
            .contentMode(.scaleAspectFit)
            .estimatedRowHeight(400)
            .isUserInteractionEnabled(true)
            .build()
        table.register(TimelineCell.self, forCellReuseIdentifier: String(describing: TimelineCell.self))
        return table
    }()
}

extension FollowViewUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.clearNavBar()
        
        vc.view.addSubview(timeline)
        timeline.addSubview(refControl)
        
        timeline.anchor()
            .edgesToSuperview()
            .activate()
    }
}
