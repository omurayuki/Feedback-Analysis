import Foundation
import FirebaseFirestore

struct Conversation: Codable {
    var id: String
    var userIDs: [String]
    var timestamp: Date
    var lastMessage: String?
    var isRead: [String: Bool]
    
    init(entity: ConversationEntity) {
        self.id = entity.id
        self.userIDs = entity.userIDs
        self.timestamp = entity.timestamp.dateValue()
        self.lastMessage = entity.lastMessage
        self.isRead = entity.isRead
    }
    
    init(userIds: [String], isRead: [String: Bool]) {
        self.id = UUID().uuidString
        self.userIDs = userIds
        self.timestamp = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        self.lastMessage = ""
        self.isRead = isRead
    }
    
    init(conversation: [String: Any]) {
        guard
            let id = conversation["id"] as? String,
            let userIDs = conversation["userIDs"] as? [String],
            let timestamp = conversation["timestamp"] as? Date,
            let lastMessage = conversation["lastMessage"] as? String,
            let isRead = conversation["isRead"] as? [String: Bool]
        else {
            self.id = ""
            self.userIDs = [String]()
            self.timestamp = Date()
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

extension Conversation {
    
    func encode() -> [String: Any] {
        return ["id": id,
                "userIDs": userIDs,
                "timestamp": timestamp,
                "lastMessage": lastMessage ?? "",
                "isRead": isRead]
    }
}
