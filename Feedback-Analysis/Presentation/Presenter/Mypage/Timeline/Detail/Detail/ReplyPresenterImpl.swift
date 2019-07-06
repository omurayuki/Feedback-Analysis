import Foundation
import RxSwift
import RxCocoa
import GrowingTextView

class ReplyPresenterImpl: NSObject, ReplyPresenter {
    var view: ReplyPresenterView!
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: DetailUseCase
    
    init(useCase: DetailUseCase) {
        self.useCase = useCase
    }
    
    func fetch() {
        print("hoge")
    }
    
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) {
        print("hoge")
    }
    
    func get(from queryRef: FirebaseQueryRef) {
        print("hoge")
    }
    
    func set(document id: String, completion: @escaping () -> Void) {
        print("hoge")
    }
    
    func getDocumentId(completion: @escaping (String) -> Void) {
        print("hoge")
    }
}

extension ReplyPresenterImpl: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.SpringAnimator(duration: 0.3, damping: 0.7, velocity: 0.7, options: [.curveLinear])
            .animations {
                self.view.didChangeTextHeight()
            }.animate()
    }
}
