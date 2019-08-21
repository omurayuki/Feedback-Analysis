import UIKit

protocol AnalysisWrapUI: UI {
    var segmented: CustomSegmentedControl { get }
    var containerView: UIView { get }
    var pages: UIPageViewController { get set }
    
    func setup()
}

final class AnalysisWrapUIImpl: AnalysisWrapUI {
    
    weak var viewController: UIViewController?
    
    private(set) var segmented: CustomSegmentedControl = {
        let segment = CustomSegmentedControl(frame: CGRect(), buttonTitle: ["強み", "分析"])
        segment.backgroundColor = .clear
        return segment
    }()
    
    private(set) var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appMainColor
        return view
    }()
    
    var pages: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        pageVC.view.backgroundColor = .appMainColor
        return pageVC
    }()
}

extension AnalysisWrapUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.navigationController?.navigationBar.barTintColor = .appMainColor
        vc.view.backgroundColor = .appMainColor
        vc.navigationItem.title = "Analysis"
        
        vc.addChild(pages)
        [segmented, containerView].forEach { vc.view.addSubview($0) }
        containerView.addSubview(pages.view)
        pages.didMove(toParent: vc)
        
        segmented.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor, multiplier: 0.95)
            .height(constant: 35)
            .activate()
        
        containerView.anchor()
            .top(to: segmented.bottomAnchor, constant: 2)
            .width(to: vc.view.widthAnchor)
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor)
            .activate()
        
        pages.view.anchor()
            .edgesToSuperview()
            .activate()
    }
}
