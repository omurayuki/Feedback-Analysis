import Foundation

struct AccountTranslator: Translator {
    func translate(_ entity: AccountEntity) -> Account {
        return Account(entity: entity)
    }
}
