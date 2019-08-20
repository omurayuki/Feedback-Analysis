import Foundation
import UIKit
import RxSwift
import RxCocoa
import Charts

final class AnalysisResultViewControllor: UIViewController {
    
    typealias DataSource = TableViewDataSource<AnalysisResultCell, (String?, Int)>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(cellReuseIdentifier: String(describing: AnalysisResultCell.self),
                          listItems: [],
                          isSkelton: false,
                          cellConfigurationHandler: { (cell, item, _) in
            cell.strengthLabel.text = item.0
            cell.strengthCountLabel.text = String(item.1)
        })
    }()
    
    @IBOutlet var pieChart: PieChartView! {
        didSet {
            pieChart.backgroundColor = .appMainColor
            pieChart.chartDescription?.text = ""
            pieChart.transparentCircleColor = .appMainColor
        }
    }
    
    @IBOutlet weak var AnalysisTableView: UITableView! {
        didSet {
            AnalysisTableView.register(AnalysisResultCell.self, forCellReuseIdentifier: String(describing: AnalysisResultCell.self))
        }
    }
    
    var presenter: AnalysisResultPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {}
    }
    
    var routing: AnalysisResultRouting!
    
    func inject(presenter: AnalysisResultPresenter,
                routing: AnalysisResultRouting,
                disposeBag: DisposeBag) {
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        presenter.fetch(queryRef: .allRef(authorToken: ""))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension AnalysisResultViewControllor: AnalysisResultPresenterView {
    
    func didFetch(completes: [Complete]) {
        dataSource.listItems = presenter.tableData
        pieChart.data = updateChartData(dataEntries: presenter.numberOfDownloadsDataEntries)
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
        routing.showCompletesPage()
    }
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
}

extension AnalysisResultViewControllor {
    
    func setupUI() {
        AnalysisTableView.tableHeaderView = pieChart
    }
    
    func updateChartData(dataEntries: [PieChartDataEntry]) -> PieChartData {
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors: [UIColor] = [.blue, .flatOrange, .purple, .red, .green]
        chartDataSet.colors = colors
        return chartData
    }
}
