import Foundation
import RxSwift

protocol SignupUseCase {
    func signup(mail: String, pass: String) -> Single<Account>
}
