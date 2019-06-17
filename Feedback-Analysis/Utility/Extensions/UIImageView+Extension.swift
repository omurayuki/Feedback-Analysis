import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(url: String) {
        
        if URL(string: url) != nil && url.count > 0 {
            let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
            self.kf.setImage(with: resource, placeholder: R.image.logo())
        }
        else{
            self.image = R.image.logo()
        }
    }
}
