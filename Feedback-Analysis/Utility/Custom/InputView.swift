import Foundation
import UIKit

class InputView: UIView {
    class Builder {
        private var title: String?
        private var hint: String?
        private var alignment: NSTextAlignment = .center
        private var keyboardType: UIKeyboardType = .default
        private var isPassword = false
        
        func title(_ title: String) -> Builder {
            self.title = title
            return self
        }
        
        func hint(_ hint: String) -> Builder {
            self.hint = hint
            return self
        }
        
        func alignment(_ alignment: NSTextAlignment) -> Builder {
            self.alignment = alignment
            return self
        }
        
        func isPassword(_ isPassword: Bool) -> Builder {
            self.isPassword = isPassword
            return self
        }
        
        func keyboardType(_ keyboardType: UIKeyboardType) -> Builder {
            self.keyboardType = keyboardType
            return self
        }
        
        func build() -> InputView {
            let inputView = InputView()
            inputView.title.text = title ?? ""
            inputView.field.placeholder = hint ?? ""
            inputView.field.isSecureTextEntry = isPassword
            inputView.field.keyboardType = keyboardType
            return inputView
        }
    }
    
    private var title: UILabel = {
        let label = UILabel()
        label.apply(.title_Black40)
        return label
    }()
    
    private var field: UITextField = {
        let field = UITextField()
        field.apply(.h4_CharcoalGrey)
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension InputView {
    private func setup() {
        [title, field].forEach { addSubview($0) }
        
        title.anchor()
            .centerXToSuperview()
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 35)
            .width(to: widthAnchor, multiplier: 0.7)
            .activate()
        
        field.anchor()
            .centerXToSuperview()
            .top(to: title.bottomAnchor, constant: 10)
            .width(to: widthAnchor, multiplier: 0.7)
            .activate()
    }
}
