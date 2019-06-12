import Foundation
import UIKit

class MainTabController: UITabBarController {
    
    var timelineVC: UIViewController
    var notificationVC: UIViewController
    var mailListVC: UIViewController
    var mypageVC: UIViewController
    
    init(timeline: UIViewController,
         notification: UIViewController,
         mailList: UIViewController,
         mypage: UIViewController) {
        timelineVC = timeline
        notificationVC = notification
        mailListVC = mailList
        mypageVC = mypage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension MainTabController {
    private func setup() {
        tabBar.barStyle = .default
        tabBar.clipsToBounds = true
        
        var resouces = [#imageLiteral(resourceName: "diary"), #imageLiteral(resourceName: "bell"), #imageLiteral(resourceName: "mail"), #imageLiteral(resourceName: "home")]
        var viewControllers: [UIViewController] = []
        
        [timelineVC, notificationVC, mailListVC, mypageVC].enumerated().forEach { index, controller in
            let navi = UINavigationController(rootViewController: controller)
            navi.tabBarItem = UITabBarItem(title: nil, image: resouces[index], tag: index)
            
            viewControllers.append(navi)
        }
        
        setViewControllers(viewControllers, animated: false)
        selectedIndex = 0
    }
}
