import UIKit

protocol SettingsUI: UI {
    var backBurItem: UIBarButtonItem { get }
    var settingsTable: UITableView { get }
    
    func setup()
}

final class SettingsUIImpl: SettingsUI {
    
    weak var viewController: UIViewController?
    
    private(set) var backBurItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        return button
    }()
    
    private(set) var settingsTable: UITableView = {
        let table = UITableView()
        table.separatorColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return table
    }()
}

extension SettingsUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.clearNavBar()
        vc.navigationItem.leftBarButtonItem = backBurItem
        
        [settingsTable].forEach { vc.view.addSubview($0) }
        
        settingsTable.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.bottomAnchor)
            .activate()
    }
}
