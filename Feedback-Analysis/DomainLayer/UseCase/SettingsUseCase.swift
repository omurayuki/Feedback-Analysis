import Foundation
import RxSwift

protocol SettingsUseCase {
    func logout() -> Single<()>
    func update(with email: String) -> Single<()>
    func update(with email: String, oldPass: String, newPass: String) -> Single<()>
    func getEmail() -> Single<String>
}

struct SettingsUseCaseImpl: SettingsUseCase {
    
    private(set) var repository: AccountRepository
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    func logout() -> Single<()> {
        return repository.logout()
    }
    
    func update(with email: String) -> Single<()> {
        return repository.update(with: email)
    }
    
    func update(with email: String, oldPass: String, newPass: String) -> Single<()> {
        return repository.update(with: email, oldPass: oldPass, newPass: newPass)
    }
    
    func getEmail() -> Single<String> {
        return repository.getEmail()
    }
}
