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
            pieChart.legend.textColor = .appSubColor
            pieChart.noDataText = "データがありません"
        }
    }
    
    @IBOutlet weak var analysisTableView: UITableView! {
        didSet {
            analysisTableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "logo"))
            analysisTableView.backgroundView?.alpha = 0.1
            analysisTableView.contentMode = .scaleAspectFit
            analysisTableView.clipsToBounds = true
            analysisTableView.backgroundColor = .appMainColor
            analysisTableView.backgroundView?.clipsToBounds = true
            analysisTableView.backgroundView?.contentMode = .scaleAspectFit
            analysisTableView.register(AnalysisResultCell.self, forCellReuseIdentifier: String(describing: AnalysisResultCell.self))
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
        
        presenter.fetch(queryRef: .completesRef)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        pieChart.animate(yAxisDuration: 0.5)
    }
}

extension AnalysisResultViewControllor: AnalysisResultPresenterView {
    
    func didFetch(completes: [Complete]) {
        completes.isEmpty ? removeTableHeader() : ()
        dataSource.listItems = presenter.tableData
        pieChart.data = updateChartData(dataEntries: presenter.numberOfDownloadsDataEntries)
    }
    
    func didSelect(indexPath: IndexPath, tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completes = presenter.completes.filter { $0.strength == dataSource.listItems[indexPath.row].0 }
        
        routing.showCompletesPage(completes)
    }
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let animator = Animator()
        
        animator.updateBlock = {
            let phaseShift = 10 * animator.phaseX
            let dataSet = chartView.data?.dataSets.first as? PieChartDataSet
            dataSet?.selectionShift = CGFloat(phaseShift)
            chartView.setNeedsDisplay()
        }
        
        animator.animate(xAxisDuration: 0.3, easingOption: .easeInCubic)
    }
}

extension AnalysisResultViewControllor {
    
    func setupUI() {
        analysisTableView.tableHeaderView = pieChart
    }
    
    func updateChartData(dataEntries: [PieChartDataEntry]) -> PieChartData {
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors: [UIColor] = [.blue, .flatOrange, .purple, .red, .green]
        chartDataSet.colors = colors
        return chartData
    }
    
    func removeTableHeader() {
        analysisTableView.tableHeaderView = nil
        analysisTableView.separatorStyle = .none
    }
}
