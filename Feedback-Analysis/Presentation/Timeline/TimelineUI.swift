import UIKit

protocol TimelineUI: UI {
    var timelineSegmented: CustomSegmentedControl { get }
    var containerView: UIView { get }
    var timelinePages: UIPageViewController { get set }
    
    func setup()
}

final class TimelineUIImpl: TimelineUI {
    
    weak var viewController: UIViewController?
    
    private(set) var timelineSegmented: CustomSegmentedControl = {
        let segment = CustomSegmentedControl(frame: CGRect(), buttonTitle: ["目標", "達成"])
        segment.backgroundColor = .clear
        return segment
    }()
    
    private(set) var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appMainColor
        return view
    }()
    
    var timelinePages: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        pageVC.view.backgroundColor = .appMainColor
        return pageVC
    }()
}

extension TimelineUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.navigationController?.navigationBar.barTintColor = .appMainColor
        vc.view.backgroundColor = .appMainColor
        vc.navigationItem.title = "Post"
        
        vc.addChild(timelinePages)
        [timelineSegmented, containerView].forEach { vc.view.addSubview($0) }
        containerView.addSubview(timelinePages.view)
        timelinePages.didMove(toParent: vc)
        
        timelineSegmented.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor, multiplier: 0.95)
            .height(constant: 35)
            .activate()
        
        containerView.anchor()
            .top(to: timelineSegmented.bottomAnchor, constant: 2)
            .width(to: vc.view.widthAnchor)
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor)
            .activate()
        
        timelinePages.view.anchor()
            .edgesToSuperview()
            .activate()
    }
}
