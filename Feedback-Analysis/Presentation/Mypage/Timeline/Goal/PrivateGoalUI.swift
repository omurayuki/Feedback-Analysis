import UIKit

final class PrivateGoalUIImpl: TimelineContentUI {
    
    weak var viewController: UIViewController?
    
    var timeline: UITableView = {
        let table = UITableView()
        table.setupTimelineComponent()
        table.register(TimelineCell.self, forCellReuseIdentifier: String(describing: TimelineCell.self))
        return table
    }()
}

extension PrivateGoalUIImpl {
    
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
