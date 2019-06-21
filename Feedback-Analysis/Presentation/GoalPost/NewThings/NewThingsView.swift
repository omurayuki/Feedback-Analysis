import UIKit

final class NewThingsView: UIView {
    
    private(set) var newThingsLabel: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub, title: "新しく始めたことを記入しましょう")
        label.textAlignment = .center
        return label
    }()
    
    private(set) var newThingsField: PaddingTextField = {
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

extension NewThingsView {
    func setup() {
        backgroundColor = .appMainColor
        
        [newThingsLabel, newThingsField].forEach { addSubview($0) }
        addGestureRecognizer(viewTapGesture)
        
        newThingsLabel.anchor()
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 35)
            .width(to: widthAnchor)
            .activate()
        
        newThingsField.anchor()
            .centerXToSuperview()
            .top(to: newThingsLabel.bottomAnchor, constant: 20)
            .width(to: widthAnchor, multiplier: 0.85)
            .height(constant: 35)
            .activate()
    }
}
