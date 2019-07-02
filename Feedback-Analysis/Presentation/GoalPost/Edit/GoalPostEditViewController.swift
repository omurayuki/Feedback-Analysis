import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class GoalPostEditViewController: UIViewController {
    
    private var startPoint: CGPoint?
    private var genres = [String]()
    private var documentId = ""
    
    var ui: GoalPostEditUI!
    
    var routing: GoalPostEditRouting!
    
    var presenter: GoalPostEditPresenter! {
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
            
            ui.saveBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.validateGoalPost(genre: self.genres,
                                          newThings: newThingsView.newThingsField.text ?? "",
                                          expectedResult1: expectedResultView.expectedResultField1.text ?? "",
                                          expectedResult2: expectedResultView.expectedResultField2.text ?? "",
                                          expectedResult3: expectedResultView.expectedResultField3.text ?? "",
                                          execute: { _genres, _newThings, _expectedResultField1, _expectedResultField2, _expectedResultField3 in
                        let goalPost = self.createGoalPost(genre: _genres,
                                                           newThings: _newThings,
                                                           expectedResultField1: _expectedResultField1,
                                                           expectedResultField2: _expectedResultField2,
                                                           expectedResultField3: _expectedResultField3,
                                                           deadline: expectedResultView.deadline.text ?? "", draft: false)
                            self.presenter.update(to: .goalUpdateRef(goalDocument: self.documentId), fields: goalPost)
                    })
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
    
    func inject(ui: GoalPostEditUI,
                presenter: GoalPostEditPresenter,
                routing: GoalPostEditRouting,
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

extension GoalPostEditViewController {
    
    func recieve(data timeline: Timeline) {
        appendGenreValue(genres: [timeline.genre1 ?? "",
                                  timeline.genre2 ?? ""])
        documentId = timeline.documentId
        ui.mappingContent = timeline
    }
    
    func appendGenreValue(genres: [String]) {
        genres.forEach {
            self.genres.append($0)
        }
    }
}

extension GoalPostEditViewController: GoalPostEditPresenterView {
    
    func didPostSuccess() {
        routing.dismiss()
    }
    
    func didSelectSegment(with index: Int) {
        UIView.Animator(duration: 0.26)
            .animations {
                self.ui.scrollView.contentOffset = CGPoint(x: Int(self.ui.scrollView.frame.width) * index, y: 0)
            }.animate()
    }
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
}
