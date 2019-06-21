import Foundation
import UIKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    
    var array: [GenreButton] = []
    var stacks: [UIStackView] = [UIStackView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMainColor
        
        array = Genre.allCases.compactMap { GenreButton(name: $0.rawValue) }
        
        stacks = [UIStackView(arrangedSubviews: array[0...3].map { $0 }),
                  UIStackView(arrangedSubviews: array[4...6].map { $0 }),
                  UIStackView(arrangedSubviews: array[7...10].map { $0 }),
                  UIStackView(arrangedSubviews: array[11...13].map { $0 }),
                  UIStackView(arrangedSubviews: array[14...17].map { $0 })].map { $0 }
            
        stacks.forEach {
            $0.spacing = 15
            view.addSubview($0)
        }
        
        array.forEach {
            $0.anchor()
                .width(constant: 70)
                .height(constant: 35)
                .activate()
        }
        
        stacks[0].anchor()
            .centerXToSuperview()
            .top(to: view.safeAreaLayoutGuide.topAnchor, constant: 20)
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
    
//    func setup() {
//        array.forEach { button in
//            button.rx.tap.asDriver()
//                .drive(onNext: { _ in
//                    button.currentState == .selected ? (button.currentState = .normal) : (button.currentState = .selected)
//                    print(button.description)
//                }).disposed(by: disposeBag)
//        }
//    }
}
