import Foundation
import UIKit
import GrowingTextView

extension GrowingTextView {
    
    class Builder {
        
        private var placeHolder: String?
        
        private var cornerRadius: CGFloat = 5
        private var trimWhiteSpaceWhenEndEditing: Bool = true
        private var font: UIFont = .systemFont(ofSize: 16)
        private var textColor: UIColor = .appSubColor
        private var backgroundColor: UIColor = UIColor(white: 0.5, alpha: 0.2)
        private var placeholderColor: UIColor = UIColor(white: 0.8, alpha: 1.0)
        
        func font(_ font: UIFont) -> Builder {
            self.font = font
            return self
        }
        
        func textColor(_ textColor: UIColor) -> Builder {
            self.textColor = textColor
            return self
        }
        
        func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            self.backgroundColor = backgroundColor
            return self
        }
        
        func cornerRadius(_ cornerRadius: CGFloat) -> Builder {
            self.cornerRadius = cornerRadius
            return self
        }
        
        func trimWhiteSpaceWhenEndEditing(_ trimWhiteSpaceWhenEndEditing: Bool) -> Builder {
            self.trimWhiteSpaceWhenEndEditing = trimWhiteSpaceWhenEndEditing
            return self
        }
        
        func placeholderColor(_ placeholderColor: UIColor) -> Builder {
            self.placeholderColor = placeholderColor
            return self
        }
        
        func placeHolder(_ placeHolder: String) -> Builder {
            self.placeHolder = placeHolder
            return self
        }
        
        func build() -> GrowingTextView {
            let textView = GrowingTextView()
            textView.font = font
            textView.textColor = textColor
            textView.backgroundColor = backgroundColor
            textView.layer.cornerRadius = cornerRadius
            textView.trimWhiteSpaceWhenEndEditing = trimWhiteSpaceWhenEndEditing
            textView.placeholder = placeHolder
            textView.placeholderColor = placeholderColor
            return textView
        }
    }
}
