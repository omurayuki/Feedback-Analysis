import Foundation
import UIKit

class PrivateDraftViewController: PrivateTimelineContentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getAuthorToken { [unowned self] token in
            self.queryRef = .draftRef(authorToken: token)
        }
    }
}
