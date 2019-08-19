import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol AnalysisPresenter {
    var startPoint: CGPoint? { get set }
    var view: AnalysisPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol AnalysisPresenterView: class {
    
    func inject(ui: AnalysisUI,
                presenter: AnalysisPresenter,
                routing: AnalysisRouting)
    func showError(message: String)
    func didSelectSegment(with index: Int)
    func updateLoading(_ isLoading: Bool)
}
