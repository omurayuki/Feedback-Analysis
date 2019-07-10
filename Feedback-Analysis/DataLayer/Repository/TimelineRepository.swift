import Foundation
import RxSwift

protocol TimelineRepository {
}

struct TimelineRepositoryImpl: TimelineRepository {
    
    static let shared = TimelineRepositoryImpl()
}
