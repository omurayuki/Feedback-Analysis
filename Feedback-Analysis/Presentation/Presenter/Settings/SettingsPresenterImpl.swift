import Foundation
import UIKit
import RxSwift

class SettingsPresenterImpl: NSObject, SettingsPresenter {
    
    var view: SettingsPresenterView!
    
    var useCase: SettingsUseCase!
    
    init(useCase: SettingsUseCase) {
        self.useCase = useCase
    }
    
    func logout() {
        useCase.logout()
            .subscribe { result in
                switch result {
                case .success(_):
                    self.view.didLogoutSuccess()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setup() {}
}

extension SettingsPresenterImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        switch section {
        case .account:
            switch indexPath.row {
            case SettingsSection.Account.passwordEdit.rawValue:
                self.view.didSelectPass()
            case SettingsSection.Account.emailEdit.rawValue:
                self.view.didSelectEmail()
            default: return
            }
        case .general:
            switch indexPath.row {
            case SettingsSection.General.logout.rawValue:
                self.view.didSelectLogout()
            default: return
            }
        }
    }
}
