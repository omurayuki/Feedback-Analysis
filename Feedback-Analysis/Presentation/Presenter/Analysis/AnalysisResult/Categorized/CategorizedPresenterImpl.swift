import Foundation
import RxSwift
import RxCocoa

class CategorizedPresenterImpl: NSObject, CategorizedPresenter {
    
    var view: CategorizedPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: TimelineUseCaseImpl
    
    init(useCase: TimelineUseCaseImpl) {
        self.useCase = useCase
    }
    
    func setup() {}
}

extension CategorizedPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
