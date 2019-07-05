import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class GoalViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<TimelineCell, Timeline>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: TimelineCell.self),
                          listItems: [],
                          cellConfigurationHandler: { (cell, item, indexPath) in
            cell.delegate = self
            cell.identificationId = indexPath.row
            cell.content = item
        })
    }()
    
    var ui: GoalUI!
    
    var routing: GoalRouting!
    
    var presenter: GoalPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: GoalUI,
                presenter: GoalPresenter,
                routing: GoalRouting,
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        self.presenter.fetch(from: .goalRef, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension GoalViewController: GoalPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didFetchGoalData(timeline: [Timeline]) {
        dataSource.listItems = []
        dataSource.listItems += timeline
        ui.timeline.reloadData()
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let height = tableView.cellForRow(at: indexPath)?.contentView.frame.height else { return }
        routing.showDetail(with: dataSource.listItems[indexPath.row], height: height)
    }
}

extension GoalViewController: CellTapDelegate {
    
    func tappedLikeBtn(index: Int) {
        // いいねされているかの情報をいいねテーブルから探してその結果をboolでここまで持ってくる
        // そしてfalseだったらサーバーにいいね情報がincrementして
        // cloud functionにその目標のいいねしたという情報を書き込む
        
        // likeGoals(commentも別で作成) documentId(document) likedUser userId(document fieldに適当な値 trueとか)(最初にこのpassがなくてもexist確認できる)
        // getDocumentで存在有無チェックはできる falseだったらtrueだったらはできる
        // trueだったらfirestoreのfieldからdecrementする
        // cloudfunctionではchange.before change.afterで書き込み前と後のデータを取ってこれた
        // これで比較できた
        // なので、likecountが増減した時に、cloudfunctionでbeforeとafterを比べて、likeGoalsから削除するか作成する
        // comment and reply and goalsが最初に作られた時に、likeGoals(commentも別で作成) documentId(document)を作成する
        
        
        // 手順
        // いいね始めての場合
        // ボタンタップ
        // likeGoalsのlikeddUsers配下から自身のtokenがあるかチェック
        // ↓ ないケース
        // like_countをincrement
        // cloudfunction発動
        // 前回値と今回値を比較 (countが0の場合、誰も更新していないということになるので、change.beforeで0という値が取れるのか(できた！！この順番でいこ！))
        // 今回値が前回値より多ければ、likeGoals/documentId/likedUser/ここにtokenをセット(適当な値をfieldにセット)
        // 今回値が前回値よりすくなければ、likeGoals/documentId/likedUser/ここにtokenを削除
        // 以降タップされれば上から繰り返す
//
//        if dataSource.listItems[index].likeCount <= 0 {
//            presenter.update(to: .goalUpdateRef(goalDocument: dataSource.listItems[index].documentId),
//                             value: ["like_count": FieldValue.increment(1.0)])
//        } else {
//            presenter.update(to: .goalUpdateRef(goalDocument: dataSource.listItems[index].documentId),
//                             value: ["like_count": FieldValue.increment(-1.0)])
//        }
        
        presenter.update(to: .goalUpdateRef(goalDocument: dataSource.listItems[index].documentId),
                         value: ["like_count": FieldValue.increment(1.0)])
    }
}
