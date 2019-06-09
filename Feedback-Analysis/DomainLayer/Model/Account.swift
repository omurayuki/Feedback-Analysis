import Foundation

struct Account {
    let authToken: String
    let email: String
    
    init(entity: AccountEntity) {
        self.authToken = entity.authToken
        self.email = entity.email
    }
}
