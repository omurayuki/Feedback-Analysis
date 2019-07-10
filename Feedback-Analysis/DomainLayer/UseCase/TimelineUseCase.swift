import Foundation
import RxSwift

protocol TimelineUseCase {
}

struct TimelineUseCaseImpl: TimelineUseCase {
    
    private(set) var repository: TimelineRepository
    
    init(repository: TimelineRepository) {
        self.repository = repository
    }
}
