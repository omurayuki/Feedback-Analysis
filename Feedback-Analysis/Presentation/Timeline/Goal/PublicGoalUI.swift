import UIKit

final class PublicGoalUIImpl: TimelineContentUI {
    
    weak var viewController: UIViewController?
    
    var timeline: UITableView = {
        let table = UITableView()
        table.setupTimelineComponent()
        table.register(TimelineCell.self, forCellReuseIdentifier: String(describing: TimelineCell.self))
        return table
    }()
}

extension PublicGoalUIImpl {
    
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
