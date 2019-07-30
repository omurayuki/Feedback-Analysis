import Foundation

struct Message {
    var id: String
    var message: String?
    var content: String?
    var contentType: ContentType?
    var time: String
    var ownerID: String?
    var profilePicLink: String?
    
    init(entity: MessageEntity) {
        self.id = entity.id
        self.message = entity.message
        self.content = entity.content
        self.contentType = ContentType(rawValue: entity.contentType)
        self.time = entity.createdAt.dateValue().offsetFrom()
        self.ownerID = entity.ownerID
        self.profilePicLink = entity.profilePicLink
    }
}
