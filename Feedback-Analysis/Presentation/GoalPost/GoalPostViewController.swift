import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class GoalPostViewController: UIViewController {
    
    private var startPoint: CGPoint?
    private var genres = [String]()
    
    var ui: GoalPostUI!
    
    var routing: GoalPostRouting!
    
    var presenter: GoalPostPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            guard let genreView = ui.slides[0] as? GenreView else { return }
            guard let newThingsView = ui.slides[1] as? NewThingsView else { return }
            guard let expectedResultView = ui.slides[2] as? ExpectedResultView else { return }
            
            ui.scrollView.rx.willBeginDragging
                .bind { [unowned self] _ in
                    self.startPoint = UIScrollView().contentOffset
                }.disposed(by: disposeBag)
            
            ui.scrollView.rx.didScroll
                .withLatestFrom(ui.scrollView.rx.contentOffset)
                .map { Int(round($0.x / UIScreen.main.bounds.width)) }
                .do(onNext: { [unowned self] page in
                    self.ui.goalPostSegmented.setIndex(index: page)
                })
                .bind(to: ui.pageControl.rx.currentPage)
                .disposed(by: disposeBag)
            
            ui.scrollView.rx.didScroll
                .bind { [unowned self] _ in
                    guard let startPoint = self.startPoint else { return }
                    self.ui.scrollView.contentOffset.y = startPoint.y
                }.disposed(by: disposeBag)
            
            ui.cancelBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.showActionSheet(title: "注意", message: "情報が失われますがよろしいですか？") {
                        self.routing.dismiss()
                    }
                }).disposed(by: disposeBag)
            
            ui.draftBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    let goalPost = GoalPost(genre: self.genres, newThings: newThingsView.newThingsField.text ?? "",
                                            goal: ["goal1": expectedResultView.expectedResultField1.text ?? "",
                                                   "goal2": expectedResultView.expectedResultField2.text ?? "",
                                                   "goal3": expectedResultView.expectedResultField3.text ?? ""],
                                            deadline: expectedResultView.deadline.text ?? "", achievedFlag: false,
                                            draftFlag: true, likeCount: 0,
                                            commentedCount: 0, createdAt: FieldValue.serverTimestamp(),
                                            updatedAt: FieldValue.serverTimestamp())
                    self.presenter.post(to: .goalPostRef, fields: goalPost)
                }).disposed(by: disposeBag)
            
            ui.saveBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    let goalPost = GoalPost(genre: self.genres, newThings: newThingsView.newThingsField.text ?? "",
                                            goal: ["goal1": expectedResultView.expectedResultField1.text ?? "",
                                                   "goal2": expectedResultView.expectedResultField2.text ?? "",
                                                   "goal3": expectedResultView.expectedResultField3.text ?? ""],
                                            deadline: expectedResultView.deadline.text ?? "", achievedFlag: false,
                                            draftFlag: false, likeCount: 0,
                                            commentedCount: 0, createdAt: FieldValue.serverTimestamp(),
                                            updatedAt: FieldValue.serverTimestamp())
                    self.presenter.post(to: .goalPostRef, fields: goalPost)
                }).disposed(by: disposeBag)
       
            genreView.array.forEach { button in
                button.rx.tap.asDriver()
                    .drive(onNext: { [unowned self] _ in
                        button.currentState == .selected ? (button.currentState = .normal) : (button.currentState = .selected)
                        button.currentState == .selected ? self.genres.append(button.description) : self.genres.remove(value: button.description)
                    }).disposed(by: disposeBag)
            }
            
            newThingsView.viewTapGesture.rx.event
                .bind { [unowned self] _ in
                    self.view.endEditing(true)
                }.disposed(by: disposeBag)
            
            expectedResultView.datePicker.rx.controlEvent(.allEvents)
                .bind { _ in
                    expectedResultView.deadline.text = expectedResultView.formatter.convertToMonthAndYears(expectedResultView.datePicker.date)
                }.disposed(by: disposeBag)
            
            expectedResultView.viewTapGesture.rx.event
                .bind { [unowned self] _ in
                    self.view.endEditing(true)
                }.disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: GoalPostUI,
                presenter: GoalPostPresenter,
                routing: GoalPostRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.routing = routing
        self.presenter = presenter
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.setupSlideScrollView(slides: ui.slides)
    }
}

extension GoalPostViewController: GoalPostPresenterView {
    
    func didPostSuccess() {
        routing.dismiss()
    }
    
    func didSelectSegment(with index: Int) {
        UIView.Animator(duration: 0.26)
            .animations {
                self.ui.scrollView.contentOffset = CGPoint(
                    x: Int(self.ui.scrollView.frame.width) * index,
                    y: 0
                )
            }.animate()
    }
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
}
