import UIKit

final class AnalysisResultCell: UITableViewCell {
    
    var strengthLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension AnalysisResultCell {
    
    private func setup() {
        
    }
}
