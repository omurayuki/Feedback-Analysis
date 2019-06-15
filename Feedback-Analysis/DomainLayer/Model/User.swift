import Foundation

struct User {
    let name: String
    let content: String
    let residence: String
    let birth: String
    let follow: Int
    let follower: Int
    
    init(entity: UserEntity) {
        self.name = entity.name
        self.content = entity.content
        self.residence = entity.residence
        self.birth = entity.birth
        self.follow = entity.follow
        self.follower = entity.follower
    }
}
