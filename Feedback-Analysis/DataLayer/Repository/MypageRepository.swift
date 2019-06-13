import Foundation
import RxSwift

protocol MypageRepository {
    
}

struct MypageRepositoryImpl: MypageRepository {
    
    static let shared = MypageRepositoryImpl()
}
