import Foundation

struct User: Codable {
    let authorToken: String?
    let headerImage: String
    let userImage: String
    let name: String
    let content: String
    let residence: String
    let birth: String
    let follow: Int
    let follower: Int
    
    init(entity: UserEntity, authorToken: String?) {
        self.authorToken = authorToken
        self.headerImage = entity.headerImage
        self.userImage = entity.userImage
        self.name = entity.name
        self.content = entity.content
        self.residence = entity.residence
        self.birth = entity.birth
        self.follow = entity.follow
        self.follower = entity.follower
    }
}
