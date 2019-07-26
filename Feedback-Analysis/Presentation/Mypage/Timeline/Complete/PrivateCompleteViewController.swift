import Foundation
import UIKit

class PrivateCompleteViewController: PrivateTimelineContentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getAuthorToken { [unowned self] token in
            self.queryRef = .completeRef(authorToken: token)
        }
    }
}
