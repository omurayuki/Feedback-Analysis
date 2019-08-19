import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class AnalysisViewController: UIViewController {
    
    var ui: AnalysisUI!
    
    var routing: AnalysisRouting!
    
    var presenter: AnalysisPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    let disposeBag = DisposeBag()
    
    func inject(ui: AnalysisUI,
                presenter: AnalysisPresenter,
                routing: AnalysisRouting) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.setupSlideScrollView(slides: ui.slides)
        bindUI()
    }
}

extension AnalysisViewController {
    
    private func bindUI() {
        guard let firstView = ui.slides[0] as? AnalysisView else { return }
        guard let secondView = ui.slides[1] as? AnalysisView else { return }
        guard let thirdView = ui.slides[2] as? AnalysisView else { return }
        guard let fourceView = ui.slides[3] as? StrengthView else { return }
        
        ui.scrollView.rx.willBeginDragging
            .bind { [unowned self] _ in
                self.presenter.startPoint = UIScrollView().contentOffset
            }.disposed(by: disposeBag)
        
        ui.scrollView.rx.didScroll
            .withLatestFrom(ui.scrollView.rx.contentOffset)
            .map { Int(round($0.x / UIScreen.main.bounds.width)) }
            .do(onNext: { [unowned self] page in
                self.ui.segment.setIndex(index: page)
            })
            .bind(to: ui.pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        ui.scrollView.rx.didScroll
            .bind { [unowned self] _ in
                guard let startPoint = self.presenter.startPoint else { return }
                self.ui.scrollView.contentOffset.y = startPoint.y
            }.disposed(by: disposeBag)
        
        [firstView, secondView, thirdView].forEach { value in
            value.viewTapGesture.rx.event
                .bind { _ in
                    value.endEditing(true)
                }.disposed(by: disposeBag)
        }
        
        Observable.of(Strength.residences)
            .bind(to: fourceView.strengthPickerView.rx.itemTitles) {
                return $1
            }.disposed(by: disposeBag)
        
        fourceView.strengthDoneBtn.rx.tap
            .bind { _ in
                fourceView.endEditing(true)
            }.disposed(by: disposeBag)
        
        fourceView.strengthPickerView.rx.modelSelected(String.self)
            .bind { str in
                fourceView.strength.text = str.first
            }.disposed(by: disposeBag)
        
        fourceView.saveBtn.rx.tap
            .bind { _ in
                print("save")
            }.disposed(by: disposeBag)
        
        presenter.isLoading
            .subscribe(onNext: { [unowned self] isLoading in
                self.view.endEditing(true)
                self.setIndicator(show: isLoading)
            }).disposed(by: disposeBag)
    }
}

extension AnalysisViewController: AnalysisPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didSelectSegment(with index: Int) {
        UIView.Animator(duration: 0.26)
            .animations {
                self.ui.scrollView.contentOffset = CGPoint(x: Int(self.ui.scrollView.frame.width) * index, y: 0)
            }.animate()
    }
}
