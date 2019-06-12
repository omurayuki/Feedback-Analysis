import Foundation

protocol Entity {}

struct AccountEntity: Entity {
    let email: String
    let authToken: String
}
