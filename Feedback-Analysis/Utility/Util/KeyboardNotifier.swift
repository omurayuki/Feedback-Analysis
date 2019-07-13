import Foundation
import UIKit

class KeyboardNotifier: NSObject {
    
    var keyboardPresent: ((_ height: CGFloat) -> Void)?
    var keyboardDismiss: ((_ hieght: CGFloat) -> Void)?
    
    func listenKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFramex(_:)),
                                               name: UIApplication.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillChangeFramex(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                    if keyboardHeight > 0 {
                        self.keyboardPresent?(keyboardHeight)
                    } else {
                        self.keyboardDismiss?(keyboardHeight)
                    }
            }
        }
    }
}

protocol KeyboardListener {
    func keyboardPresent(_ height: CGFloat)
    func keyboardDismiss(_ height: CGFloat)
    var keyboardNotifier: KeyboardNotifier! { get set }
}

extension KeyboardListener {
    
    func listenKeyboard(keyboardNotifier: KeyboardNotifier) {
        keyboardNotifier.listenKeyboard()
        keyboardNotifier.keyboardPresent = { height in
            self.keyboardPresent(height)
        }
        keyboardNotifier.keyboardDismiss = { height in
            self.keyboardDismiss(height)
        }
    }
}
