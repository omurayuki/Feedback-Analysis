import Foundation

struct Conversation {
    var id: String
    var userIDs: [String]
    var time: String
    var lastMessage: String?
    var isRead: [String: Bool]
    
    init(entity: ConversationEntity) {
        self.id = entity.id
        self.userIDs = entity.userIDs
        self.time = entity.updatedAt.dateValue().offsetFrom()
        self.lastMessage = entity.lastMessage
        self.isRead = entity.isRead
    }
    
    init(userIds: [String], isRead: [String: Bool]) {
        self.id = ""
        self.userIDs = userIds
        self.time = ""
        self.lastMessage = ""
        self.isRead = isRead
    }
}
