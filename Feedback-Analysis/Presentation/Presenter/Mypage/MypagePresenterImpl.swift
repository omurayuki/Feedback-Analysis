import Foundation
import RxSwift
import RxCocoa

class MypagePresenterImpl: MypagePresenter {
    var view: MypagePresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: MypageUseCase
    
    init(useCase: MypageUseCase) {
        self.useCase = useCase
    }
    
    func setup() {}
}
