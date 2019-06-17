import Foundation
import UIKit

extension TimelineCell {
    
    func adjustImagesSpace(images: [UIImage]? = nil) {
        let mappedImages = [leftTopImage, rightTopImage, leftBottomImage, rightBottomImage]
        if images?.count == 1 || images?.count == 2 {
            images?.enumerated().forEach { index, image in
                mappedImages[index].image = image
                if index == 0 || index == 1 {
                    mappedImages[2].isHidden = true
                    mappedImages[3].isHidden = true
                }
            }
        } else if images?.count == 3 || images?.count == 4 {
            images?.enumerated().forEach { index, image in
                mappedImages[index].image = image
            }
        } else if images?.count == nil {
            mappedImages.forEach { $0.isHidden = true }
        }
    }
}
