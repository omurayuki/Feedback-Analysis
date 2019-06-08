import Foundation
import UIKit

extension UIBarButtonItem {
    func applyTitleFont() {
        setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontBold(.fontSize17)], for: .normal)
    }
}
