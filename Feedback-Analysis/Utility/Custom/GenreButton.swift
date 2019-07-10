import UIKit

internal enum State {
    case normal
    case selected
}

final class GenreButton: UIButton {
    
    private var name: String
    
    var currentState: State = .normal {
        didSet {
            UIView.Animator(duration: 0.3, delay: 0, options: .curveEaseInOut)
                .animations { self.setup() }
                .completion { _ in }
                .animate()
        }
    }
    
    override var description: String {
        return name
    }
    
    init(name: String) {
        self.name = name
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

extension GenreButton {
    private func setup() {
        switch currentState {
        case .normal:   layoutBtn(name: name, mainColor: .appSubColor, subColor: .appMainColor)
        case .selected: layoutBtn(name: name, mainColor: .appMainColor, subColor: .appSubColor)
        default:        break
        }
    }
    
    private func layoutBtn(name: String, mainColor: UIColor, subColor: UIColor) {
        setTitle(name, for: .normal)
        setTitleColor(mainColor, for: .normal)
        backgroundColor = subColor
        layer.masksToBounds = true
        layer.cornerRadius = 14
        layer.borderColor = mainColor.cgColor
        layer.borderWidth = 1
        titleLabel?.font = .boldSystemFont(ofSize: 10)
        isUserInteractionEnabled = true
    }
}
