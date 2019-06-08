import UIKit

extension UIFont {
    
    class func font(_ size: FontSizes) -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue)
    }
    
    class func fontBold(_ size: FontSizes) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size.rawValue)
    }
    
    enum FontSizes: CGFloat {
        case fontSize30 = 30.0
        case fontSize22 = 22.0
        case fontSize20 = 20.0
        case fontSize17 = 17.0
        case fontSize14 = 14.0
        case fontSize13 = 13.0
        case fontSize12 = 12.0
        case fontSize10 = 10.0
    }
}
