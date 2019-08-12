import UIKit

final class AnalysisView: UIView {
    
    private(set) var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return formatter
    }()
    
    private(set) var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.timeZone = NSTimeZone.local
        dp.backgroundColor = .white
        dp.locale = .current
        return dp
    }()
    
    private(set) var achieveTitle: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub_bold, title: "強み投与のkdfおkdf")
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
    
    private(set) var strengthTitle: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub, title: "結果の分析")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private(set) var strength: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub)
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
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
        
        strength.text = formatter.string(from: Date())
        strength.inputView = datePicker
        
        [achieveTitle, actualAchievement, analysisField, strengthTitle, strength].forEach { addSubview($0) }
        
        addGestureRecognizer(viewTapGesture)
        
        achieveTitle.anchor()
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 35)
            .left(to: leftAnchor, constant: 20)
            .width(to: widthAnchor)
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
        
        strengthTitle.anchor()
            .top(to: analysisField.bottomAnchor, constant: 35)
            .width(to: widthAnchor)
            .activate()
        
        strength.anchor()
            .centerXToSuperview()
            .top(to: strengthTitle.bottomAnchor, constant: 20)
            .width(to: widthAnchor, multiplier: 0.85)
            .height(constant: 35)
            .activate()
    }
}
