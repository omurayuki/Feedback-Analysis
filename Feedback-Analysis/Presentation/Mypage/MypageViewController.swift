import Foundation
import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    // pageviewControllerの中に数分のtableviewを作って、それぞれがpresenterなどを持っている
    // そしてdataSourceも持っているので、それぞれが叩くことでキャッシュされる
    
    
    // 目標をタイムラインに表示
    // skeltonview
    // 目標詳細(ツイッターみたいなイメージのUI)
    // 目標編集
    // 目標投稿時のimage選択(複数)
    // push通知設定
    // validationチェック(文字数, すべて(genreの場合はgenresを見てからならエラー的な))
    // タイムライン取得
    // data切り替え()
    // tableview切り出し
    // segmentedControl切り出し
    // 投稿ボタン作成
    // 目標編集画面作成
    // コメント機能実装
    // リプライ機能実装
    // チャット機能実装
    // 強み分析機能実装
    
    private var currentIndex: Int?
    
    private var pendingIndex: Int?
    
    var ui: MypageUI!
    
    var routing: MypageRouting!
    
    var viewControllers: [UIViewController]!
    
    var presenter: MypagePresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.settingsBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveSettingsPage()
                }).disposed(by: disposeBag)
            
            ui.editBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveEditPage(user: UpdatingItem(userImage: self.ui.userImage.image ?? UIImage(),
                                                                 name: self.ui.userName.text ?? "",
                                                                 content: self.ui.contentField.text ?? "",
                                                                 residence: self.ui.residenceField.text ?? "",
                                                                 birth: self.ui.birthDayField.text ?? ""))
                }).disposed(by: disposeBag)
            
            ui.goalPostBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.routing.moveGoalPostPage()
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: MypageUI,
                presenter: MypagePresenter,
                routing: MypageRouting,
                viewControllers: [UIViewController],
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.viewControllers = viewControllers
        self.disposeBag = disposeBag
        
        self.presenter.fetch(to: .userRef, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.timelinePages.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
}

extension MypageViewController: MypagePresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchUserData(user: User) {
        ui.updateUser(user: user)
    }
    
    func didSelectSegment(with index: Int) {
        ui.timelinePages.setViewControllers([viewControllers[index]], direction: .forward, animated: true, completion: nil)
    }
    
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController]) {
        pendingIndex = viewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        currentIndex = pendingIndex
        if let index = currentIndex { ui.timelineSegmented.setIndex(index: index) }
    }
}

extension MypageViewController: UpdatingDelegate {
    func updateMypage(completion: @escaping () -> Void) {
        presenter.fetch(to: .userRef) {
            completion()
        }
    }
}

extension MypageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        if index == viewControllers.count - 1 { return nil }
        index = index + 1
        return viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        index = index - 1
        if index < 0 { return nil }
        return viewControllers[index]
    }
}
