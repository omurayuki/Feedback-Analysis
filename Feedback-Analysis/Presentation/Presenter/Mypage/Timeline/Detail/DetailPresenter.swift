import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol DetailPresenter {
    var view: DetailPresenterView! { get set }
    
}

protocol DetailPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: DetailUI,
                presenter: DetailPresenter,
                routing: DetailRouting,
                disposeBag: DisposeBag)
    func didChangeTextHeight()
    func showError(message: String)
}
