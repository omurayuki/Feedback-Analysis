import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol MessagesPresenter: Presenter {
    
    var disposeBag: DisposeBag { get }
    var conversation: Conversation! { get set }
    var view: MessagesPresenterView! { get set }
    
}

protocol MessagesPresenterView: class {
    
    func inject(presenter: MessagesPresenter,
                routing: MessagesRouting)
    
    func showError(message: String)
}
