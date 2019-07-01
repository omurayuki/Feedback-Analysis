import Foundation
import RxSwift
import RxCocoa
import GrowingTextView

class DetailPresenterImpl: NSObject, DetailPresenter {
    var view: DetailPresenterView!
}

extension DetailPresenterImpl: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.SpringAnimator(duration: 0.3, damping: 0.7, velocity: 0.7, options: [.curveLinear])
            .animations {
                self.view.didChangeTextHeight()
            }.animate()
    }
}
