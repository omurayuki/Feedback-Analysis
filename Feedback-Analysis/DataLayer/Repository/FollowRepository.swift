import Foundation
import RxSwift

protocol FollowRepository {
}

struct FollowRepositoryImpl: FollowRepository {
    
    static let shared = FollowRepositoryImpl()
}
