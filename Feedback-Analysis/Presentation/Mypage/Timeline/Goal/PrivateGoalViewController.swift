import Foundation
import UIKit

class PrivateGoalViewController: PrivateTimelineContentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getAuthorToken { [unowned self] token in
            self.queryRef = .goalRef(authorToken: token)
        }
    }
}
