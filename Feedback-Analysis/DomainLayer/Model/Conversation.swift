import Foundation
import FirebaseFirestore

struct Conversation: Codable {
    var id: String
    var userIDs: [String]
    var time: Date
    var lastMessage: String?
    var isRead: [String: Bool]
    
    init(entity: ConversationEntity) {
        self.id = entity.id
        self.userIDs = entity.userIDs
        self.time = entity.updatedAt
        self.lastMessage = entity.lastMessage
        self.isRead = entity.isRead
    }
    
    init(userIds: [String], isRead: [String: Bool]) {
        self.id = UUID().uuidString
        self.userIDs = userIds
        self.time = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        self.lastMessage = ""
        self.isRead = isRead
    }
}
