import Foundation
import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    // 設定画面作成
    // 設定画面つなぎこみ
    // 目標投稿画面作成
    // 目標投稿APIつなぎこみ
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
    
    var ui: MypageUI!
    
    var routing: MypageRouting!
    
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
        }
    }
    
    func inject(ui: MypageUI,
                presenter: MypagePresenter,
                routing: MypageRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(to: .userRef, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension MypageViewController: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        print(index)
    }
}

extension MypageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimelineCell.self),
                                                       for: indexPath) as? TimelineCell else { return UITableViewCell() }
        cell.configure(photo: #imageLiteral(resourceName: "logo"), name: "ゆうきんぐ",
                       time: "5時間前", content: "wwwwwwwwwwwwwwwww",
                       postImage: [#imageLiteral(resourceName: "川"), #imageLiteral(resourceName: "川"), #imageLiteral(resourceName: "川"), #imageLiteral(resourceName: "川")], commentted: "5", like: "13")
        return cell
    }
}

extension MypageViewController: UITableViewDelegate {
    
}

extension MypageViewController: MypagePresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchUserData(user: User) {
        ui.updateUser(user: user)
    }
}

extension MypageViewController: UpdatingDelegate {
    func updateMypage(completion: @escaping () -> Void) {
        presenter.fetch(to: .userRef) {
            completion()
        }
    }
}
