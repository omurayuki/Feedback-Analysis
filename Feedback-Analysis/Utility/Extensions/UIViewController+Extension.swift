import Foundation
import Social
import Accounts
import MessageUI
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func dismissOrPopViewController() {
        guard self.navigationController?.viewControllers.count != 1 else {
            self.navigationController?.dismiss(animated: true)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissAndEndEditing() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    func setBackButton(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setUserInteraction(enabled: Bool) {
        view.isUserInteractionEnabled = enabled
        if let navi = navigationController {
            navi.view.isUserInteractionEnabled = enabled
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController.createSimpleOkMessage(title: "エラー", message: message)
        present(alert, animated: true)
    }
    
    func validateAccount(email: String,
                         pass: String? = nil,
                         account execute: @escaping (_ email: String, _ pass: String) -> Void) {
        switch AccountValidation.validateAccount(email: email, pass: pass) {
        case .mailNotEnough(let str):     self.showError(message: str)
        case .mailExceeded(let str):      self.showError(message: str)
        case .passNotEnough(let str):     self.showError(message: str)
        case .passExceeded(let str):      self.showError(message: str)
        case .notAccurateChar(let str):   self.showError(message: str)
        case .ok(let email, let pass):    execute(email, pass ?? "")
        }
    }
    
    func setIndicator(show: Bool) {
        if show {
            MBProgressHUD.showAdded(to: view, animated: true)
        } else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func clearNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
