import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    var ui: SettingsUI!
    
    var routing: SettingsRouting!
    
    var presenter: SettingsPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.backBurItem.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.dismiss()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: SettingsUI,
                presenter: SettingsPresenter,
                routing: SettingsRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension SettingsViewController: SettingsPresenterView {
    
    func didSelectPass() {
        routing.movePassEditPage()
    }
    
    func didSelectEmail() {
        routing.moveEmailEditPage()
    }
    
    func didSelectLogout() {
        showActionSheet(title: "メッセージ", message: "ログアウトしますか？") {
            self.presenter.logout()
        }
    }
    
    func didLogoutSuccess() {
        routing.moveTopPage()
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        switch section {
        case .account: return AccountItem.sharedItems.count
        case .general: return GeneralItem.sharedItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else { return nil }
        switch section {
        case .account: return section.title
        case .general: return section.title
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .account:
            return createCell(tableView: tableView, item: AccountItem.sharedItems, indexPath: indexPath)
        case .general:
            return createCell(tableView: tableView, item: GeneralItem.sharedItems, indexPath: indexPath)
        }
    }
    
    private func createCell<T: Item>(tableView: UITableView, item: [T], indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = item[indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
