import Foundation
import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    // struct作成 そのためにapi叩く unknownのデータを取得する　済み!!そのために新規登録時にunknownのデータをfirestoreに置く
    // data切り替え
    // tableview切り出し
    // segmentedControl切り出し
    // 投稿ボタン作成
    // 編集画面作成
    
    var ui: MypageUI!
    
    var routing: MypageRouting!
    
    var presenter: MypagePresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.editBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    print("変更画面へ遷移")
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: MypageUI, presenter: MypagePresenter, routing: MypageRouting, disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
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
        cell.configure(photo: #imageLiteral(resourceName: "logo"),
                       name: "ゆうきんぐ", time: "5時間前",
                       content: "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
                       postImage: [#imageLiteral(resourceName: "logo"), #imageLiteral(resourceName: "logo"), #imageLiteral(resourceName: "logo"), #imageLiteral(resourceName: "logo")],
                       commentted: "5",
                       like: "13")
        return cell
    }
}

extension MypageViewController: UITableViewDelegate {
    
}

extension MypageViewController: MypagePresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didLoginSuccess(account: Account) {
        print(account)
    }
}
