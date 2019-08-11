import Foundation
import FirebaseFirestore

struct ConversationEntity: Entity {
    var id: String
    var userIDs: [String]
    var timestamp: Timestamp
    var lastMessage: String?
    var isRead: [String: Bool]
    
    init(document: [String: Any]) {
        guard
            let id = document["id"] as? String,
            let userIDs = document["userIDs"] as? [String],
            let timestamp = document["timestamp"] as? Timestamp,
            let lastMessage = document["lastMessage"] as? String,
            let isRead = document["isRead"] as? [String: Bool]
        else {
            self.id = ""
            self.userIDs = [String]()
            self.timestamp = Timestamp()
            self.lastMessage = ""
            self.isRead = [String: Bool]()
            return
        }
        self.id = id
        self.userIDs = userIDs
        self.timestamp = timestamp
        self.lastMessage = lastMessage
        self.isRead = isRead
    }
}
