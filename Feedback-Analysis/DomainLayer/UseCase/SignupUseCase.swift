import Foundation
import RxSwift

protocol SignupUseCase {
    func signup(email: String, pass: String) -> Single<Account>
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()>
    func getAuthorToken() -> Single<String>
}

struct SignupUseCaseImpl: SignupUseCase {
    
    private(set) var repository: AccountRepository
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    func signup(email: String, pass: String) -> Single<Account> {
        return repository
                .signup(email: email, pass: pass)
                .map { AccountTranslator().translate($0) }
    }
    
    func setData(documentRef: FirebaseDocumentRef, fields: [String : Any]) -> Single<()> {
        return repository.setData(documentRef: documentRef, fields: fields)
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
}
