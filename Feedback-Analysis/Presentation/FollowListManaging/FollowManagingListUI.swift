import UIKit

protocol FollowManagingListUI: UI {
    var followSegment: CustomSegmentedControl { get }
    var containerView: UIView { get }
    var followPages: UIPageViewController { get set }
    
    func setup()
}

final class FollowManagingListUIImpl: FollowManagingListUI {
    
    weak var viewController: UIViewController?
    
    private(set) var followSegment: CustomSegmentedControl = {
        let segment = CustomSegmentedControl(frame: CGRect(), buttonTitle: ["フォロー", "フォロワー"])
        segment.backgroundColor = .clear
        return segment
    }()
    
    private(set) var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appMainColor
        return view
    }()
    
    var followPages: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        pageVC.view.backgroundColor = .appMainColor
        return pageVC
    }()
}

extension FollowManagingListUIImpl {
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .appMainColor
        vc.coloringAppMainNavBar()
        
        vc.addChild(followPages)
        [followSegment, containerView].forEach { vc.view.addSubview($0) }
        containerView.addSubview(followPages.view)
        followPages.didMove(toParent: vc)
        
        followSegment.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor, multiplier: 0.95)
            .height(constant: 35)
            .activate()
        
        containerView.anchor()
            .top(to: followSegment.bottomAnchor, constant: 2)
            .width(to: vc.view.widthAnchor)
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor)
            .activate()
        
        followPages.view.anchor()
            .edgesToSuperview()
            .activate()
    }
}
