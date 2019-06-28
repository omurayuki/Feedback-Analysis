import UIKit

final class GenreView: UIView {
    
    private(set) var array: [GenreButton] = []
    
    private(set) var noticeLabel: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub, title: "ジャンルを選択しましょう。最大3つまで選択できます。")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var stacks: [UIStackView] = {
        let stacks = [UIStackView]()
        return stacks
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension GenreView {
    private func setup() {
        backgroundColor = .appMainColor
        
        array = Genre.allCases.compactMap { GenreButton(name: $0.rawValue) }
        
        stacks = [UIStackView(arrangedSubviews: array[0...3].map { $0 }),
                  UIStackView(arrangedSubviews: array[4...6].map { $0 }),
                  UIStackView(arrangedSubviews: array[7...10].map { $0 }),
                  UIStackView(arrangedSubviews: array[11...13].map { $0 }),
                  UIStackView(arrangedSubviews: array[14...17].map { $0 })].map { $0 }
        
        addSubview(noticeLabel)
        stacks.forEach {
            $0.spacing = 15
            addSubview($0)
        }
        
        array.forEach {
            $0.anchor()
                .width(constant: 70)
                .height(constant: 35)
                .activate()
        }
        
        noticeLabel.anchor()
            .centerXToSuperview()
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 35)
            .width(to: widthAnchor, multiplier: 0.8)
            .activate()
        
        stacks[0].anchor()
            .centerXToSuperview()
            .top(to: noticeLabel.bottomAnchor, constant: 20)
            .activate()
        
        stacks[1].anchor()
            .centerXToSuperview()
            .top(to: stacks[0].bottomAnchor, constant: 20)
            .activate()
        
        stacks[2].anchor()
            .centerXToSuperview()
            .top(to: stacks[1].bottomAnchor, constant: 20)
            .activate()
        
        stacks[3].anchor()
            .centerXToSuperview()
            .top(to: stacks[2].bottomAnchor, constant: 20)
            .activate()
        
        stacks[4].anchor()
            .centerXToSuperview()
            .top(to: stacks[3].bottomAnchor, constant: 20)
            .activate()

    }
}
