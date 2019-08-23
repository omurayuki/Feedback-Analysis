import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol AnalysisPresenter {
    var startPoint: CGPoint? { get set }
    var view: AnalysisPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    var disposeBag: DisposeBag { get set }
    
    func post(documentRef: FirebaseDocumentRef, fields: CompletePost)
}

protocol AnalysisPresenterView: class {
    
    func inject(ui: AnalysisUI,
                presenter: AnalysisPresenter,
                routing: AnalysisRouting)
    func didPostSuccess()
    func showError(message: String)
    func didSelectSegment(with index: Int)
    func updateLoading(_ isLoading: Bool)
}
