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
    
    class Builder {
        
        private var cornerRadius: CGFloat?
        private var borderWidth: CGFloat?
        
        private var isUserInteractionEnabled = true
        private var borderColor: CGColor = UIColor.white.cgColor
        private var backgroundColor: UIColor = .white
        private var clipsToBounds: Bool = true
        private var contentMode: ContentMode = .scaleAspectFill
        
        func cornerRadius(_ cornerRadius: CGFloat) -> Builder {
            self.cornerRadius = cornerRadius
            return self
        }
        
        func borderWidth(_ borderWidth: CGFloat) -> Builder {
            self.borderWidth = borderWidth
            return self
        }
        
        func borderColor(_ borderColor: CGColor) -> Builder {
            self.borderColor = borderColor
            return self
        }
        
        func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            self.backgroundColor = backgroundColor
            return self
        }
        
        func clipsToBounds(_ clipsToBounds: Bool) -> Builder {
            self.clipsToBounds = clipsToBounds
            return self
        }
        
        func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Builder {
            self.isUserInteractionEnabled = isUserInteractionEnabled
            return self
        }
        
        func contentMode(_ contentMode: ContentMode) -> Builder {
            self.contentMode = contentMode
            return self
        }
        
        func build() -> UIImageView {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = cornerRadius ?? 0
            imageView.layer.borderWidth = borderWidth ?? 0
            imageView.layer.borderColor = borderColor
            imageView.backgroundColor = backgroundColor
            imageView.clipsToBounds = clipsToBounds
            imageView.isUserInteractionEnabled = isUserInteractionEnabled
            return imageView
        }
    }
}
