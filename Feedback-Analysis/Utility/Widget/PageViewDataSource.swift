import Foundation
import UIKit

class PageViewDataSource<Controller: UIViewController>: NSObject, UIPageViewControllerDataSource {
    
    typealias C = Controller
    
    var controllers: [C]
    
    init(controllers: [C]) {
        self.controllers = controllers
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIPageViewController.generateViewController(viewControllerBefore: viewController,
                                                           viewControllers: controllers)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIPageViewController.generateViewController(viewControllerAfter: viewController,
                                                           viewControllers: controllers)
    }
}
