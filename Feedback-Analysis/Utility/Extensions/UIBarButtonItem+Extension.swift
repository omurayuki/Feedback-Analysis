import Foundation
import UIKit

extension UIBarButtonItem {
    func applyTitleFont() {
        setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontBold(.fontSize17)], for: .normal)
    }
}
