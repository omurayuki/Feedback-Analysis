import UIKit
import SkeletonView

extension UITableViewCell {
    
    func showSkelton(_ views: UIView...) {
        views.forEach { $0.showSkeleton() }
    }
    
    func hideSkelton(_ views: UIView...) {
        views.forEach { $0.hideSkeleton() }
    }
}
