import Foundation
import UIKit

class PrivateCompleteViewController: PrivateTimelineContentViewController {
    
    var recieveToken: String
    
    init(recieveToken: String) {
        self.recieveToken = recieveToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.queryRef = .completeRef(authorToken: recieveToken)
    }
}
