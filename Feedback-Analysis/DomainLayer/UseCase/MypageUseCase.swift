import Foundation
import RxSwift

protocol MypageUseCase {
    
}

struct MypageUseCaseImpl: MypageUseCase {
    
    private(set) var repository: MypageRepository
    
    init(repository: MypageRepository) {
        self.repository = repository
    }
}
