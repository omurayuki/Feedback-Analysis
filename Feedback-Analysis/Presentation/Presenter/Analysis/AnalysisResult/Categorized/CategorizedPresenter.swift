import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol CategorizedPresenter: Presenter {
    var view: CategorizedPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol CategorizedPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: CategorizedUI,
                presenter: CategorizedPresenter,
                routing: CategorizedRouting,
                disposeBag: DisposeBag)
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
