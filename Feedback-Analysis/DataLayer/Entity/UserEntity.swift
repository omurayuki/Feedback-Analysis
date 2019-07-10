import Foundation

struct UserEntity: Entity, Codable {
    let headerImage: String
    let userImage: String
    let name: String
    let content: String
    let residence: String
    let birth: String
    let follow: Int
    let follower: Int
    
    init(document: [String: Any]) {
        guard
            let headerImage = document["header_image"] as? String,
            let userImage = document["user_image"] as? String,
            let name = document["name"] as? String,
            let content = document["content"] as? String,
            let residence = document["residence"] as? String,
            let birth = document["birth"] as? String,
            let follow = document["follow"] as? Int,
            let follower = document["follower"] as? Int
        else {
            self.headerImage = ""
            self.userImage = ""
            self.name = ""
            self.content = ""
            self.residence = ""
            self.birth = ""
            self.follow = 0
            self.follower = 0
            return
        }
        self.headerImage = headerImage
        self.userImage = userImage
        self.name = name
        self.content = content
        self.residence = residence
        self.birth = birth
        self.follow = follow
        self.follower = follower
    }
}
