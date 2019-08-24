import UIKit

final class AnalysisView: UIView {
    
    private(set) var achieveTitle: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub_bold)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var actualAchievement: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub, hint: "実際の成果")
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var analysisField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .appSubColor
        textView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    private(set) var viewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension AnalysisView {
    
    func setup() {
        backgroundColor = .appMainColor
        
        [achieveTitle, actualAchievement, analysisField].forEach { addSubview($0) }
        
        addGestureRecognizer(viewTapGesture)
        
        achieveTitle.anchor()
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 35)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        actualAchievement.anchor()
            .centerXToSuperview()
            .top(to: achieveTitle.bottomAnchor, constant: 20)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .height(constant: 35)
            .activate()
        
        analysisField.anchor()
            .centerXToSuperview()
            .top(to: actualAchievement.bottomAnchor, constant: 20)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .height(constant: 350)
            .activate()
    }
}
