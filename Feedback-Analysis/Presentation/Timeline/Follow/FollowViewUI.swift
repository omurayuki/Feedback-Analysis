import UIKit

final class FollowViewUIImpl: TimelineContentUI {
    
    weak var viewController: UIViewController?
    
    var timeline: UITableView = {
        let table = UITableView()
        table.setupTimelineComponent()
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
        
        timeline.anchor()
            .edgesToSuperview()
            .activate()
    }
}
