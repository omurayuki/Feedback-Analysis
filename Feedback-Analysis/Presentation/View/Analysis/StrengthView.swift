import UIKit

final class StrengthView: UIView {
    
    private(set) var strength: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub)
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var strengthDoneBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        return button
    }()
    
    private(set) var strengthToolBar: UIToolbar = {
        let toolbarFrame = CGRect(x: 0, y: 0, width: UIViewController().view.frame.width, height: 35)
        let accessoryToolbar = UIToolbar(frame: toolbarFrame)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryToolbar.items = [flexibleSpace]
        accessoryToolbar.barTintColor = .white
        return accessoryToolbar
    }()
    
    private(set) var strengthPickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = .white
        return pv
    }()
    
    private(set) var saveBtn: UIButton = {
        let button = UIButton.Builder()
            .title("送信")
            .component(.title_White)
            .backgroundColor(.appSubColor)
            .cornerRadius(7)
            .build()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension StrengthView {
    
    func setup() {
        backgroundColor = .appMainColor
        
        strengthToolBar.items = [strengthDoneBtn]
        strength.inputView = strengthPickerView
        strength.inputAccessoryView = strengthToolBar
        
        [strength, saveBtn].forEach { addSubview($0) }
        
        strength.anchor()
            .centerXToSuperview()
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 50)
            .width(to: widthAnchor, multiplier: 0.85)
            .height(constant: 35)
            .activate()
        
        saveBtn.anchor()
            .centerXToSuperview()
            .top(to: strength.bottomAnchor, constant: 35)
            .width(to: widthAnchor, multiplier: 0.7)
            .height(constant: 50)
            .activate()
    }
}
