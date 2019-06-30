import UIKit

protocol DetailUI: UI {
    var detail: UITableView { get set }
    var commentTable: UITableView { get set }
    var editBtn: UIBarButtonItem { get }
    
    func setup()
    func determineHeight(height: CGFloat)
}

final class DetailUIImpl: DetailUI {
    
    var viewController: UIViewController?
    
    private(set) var editBtn: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "編集"
        item.style = .plain
        return item
    }()
    
    var detail: UITableView = {
        let table = UITableView()
        table.backgroundColor = .appMainColor
        table.separatorColor = .appSubColor
        table.separatorInset = .zero
        table.estimatedRowHeight = 400
        table.rowHeight = UITableView.automaticDimension
        table.register(TimelineCell.self, forCellReuseIdentifier: String(describing: TimelineCell.self))
        return table
    }()
    
    var commentTable: UITableView = {
        let table = UITableView()
        return table
    }()
}

extension DetailUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.navigationItem.rightBarButtonItem = editBtn
        vc.view.backgroundColor = .appMainColor
        [detail, commentTable].forEach { vc.view.addSubview($0) }
        
        detail.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .activate()
        
        commentTable.anchor()
            .top(to: detail.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
    }
    
    func determineHeight(height: CGFloat) {
        detail.anchor().height(constant: height).activate()
    }
}
