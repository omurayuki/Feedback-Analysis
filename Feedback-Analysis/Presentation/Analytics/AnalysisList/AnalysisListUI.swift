import UIKit

protocol AnalysisListUI: UI {
    var tableView: UITableView { get }
    
    func setup()
}

final class AnalysisListUIImpl: AnalysisListUI {
    
    var viewController: UIViewController?
    
    private(set) var tableView: UITableView = {
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

extension AnalysisListUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.title = "分析"
        vc.navigationItem.titleView?.tintColor = .appSubColor
        vc.navigationController?.navigationBar.tintColor = .appSubColor
        
        vc.view.addSubview(tableView)
        
        tableView.anchor()
            .edgesToSuperview()
            .activate()
    }
}
