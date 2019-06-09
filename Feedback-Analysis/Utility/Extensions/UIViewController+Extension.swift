import Foundation
import Social
import Accounts
import MessageUI
import UIKit

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
}
