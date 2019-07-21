import Foundation

struct UsersTranslator: Translator {
    func translate(_ entities: [UserEntity]) -> [User] {
        return entities.map { UserTranslator().translate($0) }
    }
}

struct UserTranslator {
    
    func translate(_ entity: UserEntity) -> User {
        return User(entity: entity, authorToken: entity.authorToken)
    }
}
