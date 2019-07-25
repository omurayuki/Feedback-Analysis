import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class PublicCompleteViewController: GoalsBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        queryRef = .publicCompleteRef
    }
}
