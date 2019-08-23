import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class AnalysisViewController: UIViewController {
    
    private var goalDocumentId = String()
    
    private var goal1 = String()
    
    private var goal2 = String()
    
    private var goal3 = String()
    
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
        
        fourceView.strengthPickerView.rx.modelSelected(String.self).asDriver()
            .drive(onNext: { str in
                fourceView.strength.text = str.first
            }).disposed(by: disposeBag)
        
        fourceView.strengthDoneBtn.rx.tap
            .bind { _ in
                fourceView.strength.resignFirstResponder()
            }.disposed(by: disposeBag)
        
        fourceView.saveBtn.rx.tap
            .bind { [unowned self] _ in
                self.presenter.post(documentRef: .completePostRef,
                                    fields: CompletePost(actualAchievement: [firstView.actualAchievement.text ?? "",
                                                                             secondView.actualAchievement.text ?? "",
                                                                             thirdView.actualAchievement.text ?? ""],
                                                         analysis: [firstView.analysisField.text ?? "",
                                                                    secondView.analysisField.text ?? "",
                                                                    thirdView.analysisField.text ?? ""],
                                                         strength: fourceView.strength.text ?? "",
                                                         goalDocumentId: self.goalDocumentId,
                                                         goal1: self.goal1,
                                                         goal2: self.goal2,
                                                         goal3: self.goal3,
                                                         createdAt: FieldValue.serverTimestamp()))
            }.disposed(by: disposeBag)
        
        presenter.isLoading
            .subscribe(onNext: { [unowned self] isLoading in
                self.view.endEditing(true)
                self.setIndicator(show: isLoading)
            }).disposed(by: disposeBag)
    }
    
    func recieve(data: Timeline) {
        guard let firstView = ui.slides[0] as? AnalysisView else { return }
        guard let secondView = ui.slides[1] as? AnalysisView else { return }
        guard let thirdView = ui.slides[2] as? AnalysisView else { return }
        
        firstView.achieveTitle.text = data.goal1
        secondView.achieveTitle.text = data.goal2
        thirdView.achieveTitle.text = data.goal3
        
        goalDocumentId = data.documentId
        goal1 = data.goal1 ?? ""
        goal2 = data.goal2 ?? ""
        goal3 = data.goal3 ?? ""
    }
}

extension AnalysisViewController: AnalysisPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didPostSuccess() {
        routing.dismiss()
    }
    
    func didSelectSegment(with index: Int) {
        UIView.Animator(duration: 0.26)
            .animations {
                self.ui.scrollView.contentOffset = CGPoint(x: Int(self.ui.scrollView.frame.width) * index, y: 0)
            }.animate()
    }
}
