import Foundation
import RxSwift

protocol LoginUseCase {
    func login(email: String, pass: String) -> Single<Account>
}

struct LoginUseCaseImpl: LoginUseCase {
    
    private(set) var repository: AccountRepository
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    func login(email: String, pass: String) -> Single<Account> {
        return repository
                .login(email: email, pass: pass)
                .map { AccountTranslator().translate($0) }
    }
}
