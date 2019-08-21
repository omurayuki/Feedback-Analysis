import UIKit

final class CompleteCell: UITableViewCell {
    
    var goalTitle1: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey16)
        label.numberOfLines = 0
        return label
    }()
    
    var goalTitle2: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey16)
        label.numberOfLines = 0
        return label
    }()
    
    var goalTitle3: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey16)
        label.numberOfLines = 0
        return label
    }()
    
    var completeTitle1: UILabel = {
        let label = UILabel()
        label.apply(.h5)
        label.numberOfLines = 0
        return label
    }()
    
    var completeTitle2: UILabel = {
        let label = UILabel()
        label.apply(.h5)
        label.numberOfLines = 0
        return label
    }()
    
    var completeTitle3: UILabel = {
        let label = UILabel()
        label.apply(.h5)
        label.numberOfLines = 0
        return label
    }()
    
    var time: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey13)
        return label
    }()
    
    var content: Complete! {
        didSet {
            goalTitle1.text = "目標: \(content.goal1)"
            goalTitle2.text = "目標: \(content.goal2)"
            goalTitle3.text = "目標: \(content.goal3)"
            completeTitle1.text = "実際: \(content.actualAchievement[0])"
            completeTitle2.text = "実際: \(content.actualAchievement[1])"
            completeTitle3.text = "実際: \(content.actualAchievement[2])"
            time.text = content.time
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension CompleteCell {
    
    private func setup() {
        backgroundColor = .appMainColor
        
        [goalTitle1, goalTitle2, goalTitle3,
         completeTitle1, completeTitle2, completeTitle3, time].forEach { addSubview($0) }
        
        goalTitle1.anchor()
            .top(to: topAnchor, constant: 15)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        completeTitle1.anchor()
            .top(to: goalTitle1.bottomAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        goalTitle2.anchor()
            .top(to: completeTitle1.bottomAnchor, constant: 15)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        completeTitle2.anchor()
            .top(to: goalTitle2.bottomAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        goalTitle3.anchor()
            .top(to: completeTitle2.bottomAnchor, constant: 15)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        completeTitle3.anchor()
            .top(to: goalTitle3.bottomAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .bottom(to: bottomAnchor, constant: -15)
            .activate()
        
        time.anchor()
            .top(to: topAnchor, constant: 15)
            .right(to: rightAnchor, constant: -20)
            .activate()
    }
}
