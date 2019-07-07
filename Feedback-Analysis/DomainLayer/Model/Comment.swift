import Foundation

struct Comment {
    let userImage: String
    let name: String
    let authorToken: String
    let comment: String
    var likeCount: Int
    let repliedCount: Int
    let documentId: String
    
    init(entity: CommentEntity) {
        self.userImage = entity.user.userImage
        self.name = entity.user.name
        self.authorToken = entity.authorToken
        self.comment = entity.comment
        self.likeCount = entity.likeCount
        self.repliedCount = entity.repliedCount
        self.documentId = entity.documentId
    }
}
