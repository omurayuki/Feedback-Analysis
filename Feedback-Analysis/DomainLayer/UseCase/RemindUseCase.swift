import Foundation
import RxSwift

protocol RemindUseCase {
    func reissuePassword(email: String) -> Single<()>
}

struct RemindUseCaseImpl: RemindUseCase {
    
    private(set) var repository: AccountRepository
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    func reissuePassword(email: String) -> Single<()> {
        return repository.reissuePassword(email: email)
    }
}
