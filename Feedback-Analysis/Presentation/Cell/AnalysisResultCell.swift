import UIKit

final class AnalysisResultCell: UITableViewCell {
    
    var strengthLabel: UILabel = {
        let label = UILabel()
        label.apply(.h3_Bold)
        return label
    }()
    
    var strengthCountLabel: UILabel = {
        let label = UILabel()
        label.apply(.h4_Bold)
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
        backgroundColor = .appMainColor
        [strengthLabel, strengthCountLabel].forEach { addSubview($0) }
        
        strengthLabel.anchor()
            .top(to: topAnchor, constant: 50)
            .bottom(to: bottomAnchor, constant: -50)
            .left(to: leftAnchor, constant: 20)
            .activate()
        
        strengthCountLabel.anchor()
            .top(to: topAnchor, constant: 50)
            .bottom(to: bottomAnchor, constant: -50)
            .right(to: rightAnchor, constant: -20)
            .activate()
    }
}
