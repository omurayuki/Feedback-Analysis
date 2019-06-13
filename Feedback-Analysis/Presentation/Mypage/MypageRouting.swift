import Foundation
import UIKit
import RxSwift

protocol MypageRouting: Routing {
    
}

final class MypageRoutingImpl: MypageRouting {
    
    var viewController: UIViewController?
}
