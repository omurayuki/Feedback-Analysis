import TransitionableTab

class TransitionableTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension TransitionableTabBarController: TransitionableTab {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}
