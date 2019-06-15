import Foundation

struct UserTranslator: Translator {
    func translate(_ entity: UserEntity) -> User {
        return User(entity: entity)
    }
}
