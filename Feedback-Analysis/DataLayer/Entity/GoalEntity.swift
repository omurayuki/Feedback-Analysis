import Foundation
import FirebaseFirestore

////    let postImage: [String]?
struct GoalEntity: Entity {
    let authorToken: String
    let user: UserEntity?
    let genre: [String: String]
    let newThings: String
    let goal: [String: String]
    let achievedFlag: Bool
    let draftFlag: Bool
    let deadLine: Timestamp
    let likeCount: Int
    let commentedCount: Int
    let createdAt: Timestamp
    let documentId: String
    
    init(user: UserEntity?, document: [String: Any], documentId: String) {
        guard
            let authorToken = document["author_token"] as? String,
            let genre = document["genre"] as? [String: String],
            let newThings = document["new_things"] as? String,
            let goal = document["goal"] as? [String: String],
            let achievedFlag = document["achieved_flag"] as? Bool,
            let draftFlag = document["draft_flag"] as? Bool,
            let deadLine = document["deadline"] as? Timestamp,
            let likeCount = document["like_count"] as? Int,
            let commentedCount = document["commented_count"] as? Int,
            let createdAt = document["created_at"] as? Timestamp
        else {
            self.authorToken = ""
            self.user = UserEntity(document: ["": ""])
            self.genre = ["": ""]
            self.newThings = ""
            self.goal = ["": ""]
            self.achievedFlag = false
            self.draftFlag = false
            self.deadLine = Timestamp()
            self.likeCount = 0
            self.commentedCount = 0
            self.createdAt = Timestamp()
            self.documentId = ""
            return
        }
        
        self.authorToken = authorToken
        self.user = user
        self.genre = genre
        self.newThings = newThings
        self.goal = goal
        self.achievedFlag = achievedFlag
        self.draftFlag = draftFlag
        self.deadLine = deadLine
        self.likeCount = likeCount
        self.commentedCount = commentedCount
        self.createdAt = createdAt
        self.documentId = documentId
    }
}
