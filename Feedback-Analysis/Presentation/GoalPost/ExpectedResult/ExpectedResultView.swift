import UIKit

final class ExpectedResultView: UIView {
    
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
    
    private(set) var expextedLabel: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub, title: "期待する成果について具体的に記入しましょう")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private(set) var expectedResultField1: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub, hint: "ex) ◯◯を任されるようになる")
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var expectedResultField2: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub, hint: "ex) ◯◯なスキルを高める")
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var expectedResultField3: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub, hint: "ex) ◯◯を完了させる")
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var deadlineLable: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub, title: "それらの期限について具体的に記入しましょう")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private(set) var deadline: PaddingTextField = {
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

extension ExpectedResultView {
    private func setup() {
        backgroundColor = .appMainColor
        
        deadline.text = formatter.string(from: Date())
        deadline.inputView = datePicker
        
        [expextedLabel, expectedResultField1, expectedResultField2,
         expectedResultField3, deadlineLable, deadline].forEach { addSubview($0) }
        addGestureRecognizer(viewTapGesture)
        
        expextedLabel.anchor()
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 35)
            .width(to: widthAnchor)
            .activate()
        
        expectedResultField1.anchor()
            .centerXToSuperview()
            .top(to: expextedLabel.bottomAnchor, constant: 20)
            .width(to: widthAnchor, multiplier: 0.85)
            .height(constant: 35)
            .activate()
        
        expectedResultField2.anchor()
            .centerXToSuperview()
            .top(to: expectedResultField1.bottomAnchor, constant: 35)
            .width(to: widthAnchor, multiplier: 0.85)
            .height(constant: 35)
            .activate()
        
        expectedResultField3.anchor()
            .centerXToSuperview()
            .top(to: expectedResultField2.bottomAnchor, constant: 35)
            .width(to: widthAnchor, multiplier: 0.85)
            .height(constant: 35)
            .activate()
        
        deadlineLable.anchor()
            .top(to: expectedResultField3.bottomAnchor, constant: 35)
            .width(to: widthAnchor)
            .activate()
        
        deadline.anchor()
            .centerXToSuperview()
            .top(to: deadlineLable.bottomAnchor, constant: 20)
            .width(to: widthAnchor, multiplier: 0.85)
            .height(constant: 35)
            .activate()
    }
}
