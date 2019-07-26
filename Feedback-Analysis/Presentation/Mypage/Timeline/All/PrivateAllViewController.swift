import Foundation
import UIKit

class PrivateAllViewController: PrivateTimelineContentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getAuthorToken { [unowned self] token in
            self.queryRef = .allRef(authorToken: token)
        }
    }
}
