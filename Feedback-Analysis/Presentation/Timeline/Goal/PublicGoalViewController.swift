import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class PublicGoalViewController: GoalsBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryRef = .publicGoalRef
    }
}
