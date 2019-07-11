import Foundation
import UIKit

extension UITableView {
    
    class Builder {
        
        private var backgroundImage: UIImage?
        private var contentMode: ContentMode?
        private var estimatedRowHeight: CGFloat?
        
        private var clipToBounds: Bool = true
        private var backgroundColor: UIColor = .appMainColor
        private var separatorColor: UIColor = .appCoolGrey
        private var rowHeight: CGFloat = UITableView.automaticDimension
        private var backgroundAlpha: CGFloat = 1
        private var tableFooterView = UIView()
        
        func backgroundImage(_ backgroundImage: UIImage) -> Builder {
            self.backgroundImage = backgroundImage
            return self
        }
        
        func clipToBounds(_ clipToBounds: Bool) -> Builder {
            self.clipToBounds = clipToBounds
            return self
        }
        
        func contentMode(_ contentMode: ContentMode) -> Builder {
            self.contentMode = contentMode
            return self
        }
        
        func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            self.backgroundColor = backgroundColor
            return self
        }
        
        func separatorColor(_ separatorColor: UIColor) -> Builder {
            self.separatorColor = separatorColor
            return self
        }
        
        func estimatedRowHeight(_ estimatedRowHeight: CGFloat) -> Builder {
            self.estimatedRowHeight = estimatedRowHeight
            return self
        }
        
        func rowHeight(_ rowHeight: CGFloat) -> Builder {
            self.rowHeight = rowHeight
            return self
        }
        
        func backgroundAlpha(_ backgroundAlpha: CGFloat) -> Builder {
            self.backgroundAlpha = backgroundAlpha
            return self
        }
        
        func tableFooterView(_ tableFooterView: UIView) -> Builder {
            self.tableFooterView = tableFooterView
            return self
        }
        
        func build() -> UITableView {
            let table = UITableView()
            table.backgroundView = UIImageView(image: backgroundImage)
            table.backgroundView?.alpha = backgroundAlpha
            table.clipsToBounds = clipToBounds
            table.contentMode = contentMode ?? .scaleAspectFit
            table.backgroundColor = backgroundColor
            table.separatorColor = separatorColor
            table.tableFooterView = tableFooterView
            table.estimatedRowHeight = estimatedRowHeight ?? 400
            table.rowHeight = rowHeight
            return table
        }
    }
}
