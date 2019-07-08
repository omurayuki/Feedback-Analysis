import Foundation

struct Reply {
    let userImage: String
    let name: String
    let authorToken: String
    let time: String
    let reply: String
    let documentId: String
    
    init(entity: ReplyEntity) {
        self.userImage = entity.user.userImage
        self.name = entity.user.name
        self.authorToken = entity.authorToken
        self.time = "5時間前"
        self.reply = entity.reply
        self.documentId = entity.documentId
    }
}
