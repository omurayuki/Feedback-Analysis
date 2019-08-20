import UIKit

protocol AnalysisUI: UI {
    var slides: [UIView] { get set }
    var segment: CustomSegmentedControl { get }
    var viewTapGesture: UITapGestureRecognizer { get }
    var saveBtn: UIBarButtonItem { get }
    var scrollView: UIScrollView { get }
    var pageControl: UIPageControl { get }
    
    func setup()
    func setupSlideScrollView(slides: [UIView])
}

final class AnalysisUIImpl: AnalysisUI {
    
    weak var viewController: UIViewController?
    
    var slides: [UIView] = []
    
    private(set) var segment: CustomSegmentedControl = {
        let segment = CustomSegmentedControl(frame: CGRect(), buttonTitle: ["ぶ", "ん", "せ", "き"])
        segment.backgroundColor = .clear
        return segment
    }()
    
    private(set) var viewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    private(set) var saveBtn: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "保存"
        item.style = .plain
        return item
    }()
    
    private(set) var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    private(set) var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .appMainColor
        control.currentPageIndicatorTintColor = .appSubColor
        control.currentPage = 0
        return control
    }()
}

extension AnalysisUIImpl {
    func setup() {
        
        guard let vc = viewController else { return }
        vc.navigationController?.navigationItem.rightBarButtonItem = saveBtn
        vc.view.backgroundColor = .appMainColor
        
        vc.view.addGestureRecognizer(viewTapGesture)
        [segment, scrollView, pageControl].forEach { vc.view.addSubview($0) }
        
        segment.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor, multiplier: 0.95)
            .height(constant: 35)
            .activate()
        
        scrollView.anchor()
            .top(to: segment.bottomAnchor, constant: 2)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .height(constant: vc.view.frame.size.height)
            .activate()
        
        pageControl.anchor()
            .centerXToSuperview()
            .bottom(to: vc.view.bottomAnchor, constant: -50)
            .width(constant: vc.view.frame.size.width / 1.5)
            .activate()
    }
    
    func setupSlideScrollView(slides: [UIView]) {
        guard let vc = viewController else { return }
        pageControl.numberOfPages = slides.count
        scrollView.frame = CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height)
        scrollView.contentSize = CGSize(width: vc.view.frame.width * CGFloat(slides.count), height: vc.view.frame.height)
        slides.enumerated().forEach { index, slide in
            slide.frame = CGRect(x: vc.view.frame.width * CGFloat(index), y: 0, width: vc.view.frame.width, height: vc.view.frame.height)
            scrollView.addSubview(slide)
        }
    }
}
