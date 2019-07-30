import Foundation
import FirebaseFirestore

struct ConversationEntity: Entity {
    var id: String
    var userIDs: [String]
    var updatedAt: Timestamp
    var lastMessage: String?
    var isRead: [String: Bool]
    
    init(document: [String: Any]) {
        guard
            let id = document["id"] as? String,
            let userIDs = document["userIDs"] as? [String],
            let updatedAt = document["updated_at"] as? Timestamp,
            let lastMessage = document["last_message"] as? String,
            let isRead = document["is_read"] as? [String: Bool]
        else {
            self.id = ""
            self.userIDs = [String]()
            self.updatedAt = Timestamp()
            self.lastMessage = ""
            self.isRead = [String: Bool]()
            return
        }
        self.id = id
        self.userIDs = userIDs
        self.updatedAt = updatedAt
        self.lastMessage = lastMessage
        self.isRead = isRead
    }
}
