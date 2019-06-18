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
    
    func showSuccess(message: String) {
        let alert = UIAlertController.createSimpleOkMessage(title: "成功", message: message)
        present(alert, animated: true)
    }
    
    func validatePasswordMatch(pass: String, rePass: String, completion: @escaping (_ pass: String?) -> Void) {
        pass == rePass ? completion(pass) : completion(nil)
    }
    
    func validateAccount(email: String,
                         pass: String? = nil,
                         rePass: String? = nil,
                         account execute: @escaping (_ email: String, _ pass: String, _ rePass: String) -> Void) {
        switch AccountValidation.validateAccount(email: email, pass: pass, rePass: rePass) {
        case .mailNotEnough(let str):     self.showError(message: str)
        case .mailExceeded(let str):      self.showError(message: str)
        case .passNotEnough(let str):     self.showError(message: str)
        case .passExceeded(let str):      self.showError(message: str)
        case .notAccurateChar(let str):   self.showError(message: str)
        case .ok(let email, let pass, let rePass):    execute(email, pass ?? "", rePass ?? "")
        }
    }
    
    func validateUser(name: String, content: String,
                      residence: String, birth: String,
                      account execute: @escaping (_ name: String, _ content: String, _ residence: String, _ birth: String) -> Void) {
        switch UserValidation.validateUser(name: name, content: content, residence: residence, birth: birth) {
        case .empty(let str):            self.showError(message: str)
        case .nameExceeded(let str):     self.showError(message: str)
        case .contentExceeded(let str):  self.showError(message: str)
        case .ok(let name,
                 let content,
                 let residence,
                 let birth): execute(name, content, residence, birth)
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
