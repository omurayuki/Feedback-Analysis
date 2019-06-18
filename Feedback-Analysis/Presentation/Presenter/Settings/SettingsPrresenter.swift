import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SettingsPrresenter: Presenter {
    var view: SettingsPrresenterView! { get set }
    
    func logout()
}

protocol SettingsPrresenterView: class {
    func inject(ui: SettingsUI,
                presenter: SettingsPrresenter,
                routing: SettingsRouting)
    func didLogoutSuccess()
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
