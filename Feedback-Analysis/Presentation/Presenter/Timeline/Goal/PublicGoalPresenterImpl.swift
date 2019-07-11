import Foundation
import RxSwift
import RxCocoa

class PublicGoalPresenterImpl: NSObject, PublicGoalPresenter {
    var view: PublicGoalPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: TimelineUseCase
    
    init(useCase: TimelineUseCase) {
        self.useCase = useCase
    }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?) {
        print("ok")
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) {
        print("ok")
    }
    
    func get(documentRef: FirebaseDocumentRef) {
        print("ok")
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) {
        print("ok")
    }
    
    func delete(documentRef: FirebaseDocumentRef) {
        print("ok")
    }
    
    func setSelected(index: Int) {
        print("ok")
    }
    
    func getSelected(completion: @escaping (Int) -> Void) {
        print("ok")
    }
    
    func getAuthorToken(completion: @escaping (String) -> Void) {
        print("ok")
    }
}

extension PublicGoalPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
