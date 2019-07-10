import Foundation
import UIKit

extension UITableView {
    
    func setupTimelineComponent() {
        backgroundView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        backgroundView?.alpha = 0.1
        backgroundView?.clipsToBounds = true
        backgroundView?.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundColor = .appMainColor
        separatorColor = .appCoolGrey
        tableFooterView = UIView()
        estimatedRowHeight = 400
        rowHeight = UITableView.automaticDimension
    }
}
