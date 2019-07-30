import Foundation
import FirebaseFirestore

struct MessageEntity: Entity {
    var id: String
    var message: String?
    var content: String?
    var contentType: Int
    var createdAt: Timestamp
    var ownerID: String?
    var profilePicLink: String?
    
    init(document: [String: Any]) {
        guard
            let id = document["id"] as? String,
            let message = document["message"] as? String,
            let content = document["content"] as? String,
            let contentType = document["contentType"] as? Int,
            let createdAt = document["created_at"] as? Timestamp,
            let ownerID = document["ownerID"] as? String,
            let profilePicLink = document["profile_pic_link"] as? String
        else {
                self.id = ""
                self.message = ""
                self.content = ""
                self.contentType = 0
                self.createdAt = Timestamp()
                self.ownerID = ""
                self.profilePicLink = ""
                return
            }
        self.id = id
        self.message = message
        self.content = content
        self.contentType = contentType
        self.createdAt = createdAt
        self.ownerID = ownerID
        self.profilePicLink = profilePicLink
    }
}
