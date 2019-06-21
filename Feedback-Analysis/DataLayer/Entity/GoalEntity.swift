import Foundation
import FirebaseFirestore

struct GoalEntity: Entity {
    let user: UserEntity
    let genre: [String]
    let newThings: String
    let goal: [String: String]
    let achievedFlag: Bool
    let draftFlag: Bool
//    let postImage: [String]?
    let likeCount: Int
    let commentedCount: Int
    let createdAt: Timestamp
    // commentId, replyIdどうするか
    
    init(user: UserEntity, document: [String: Any]) {
        guard
            let genre = document["genre"] as? [String],
            let newThings = document["new_things"] as? String,
            let goal = document["goal"] as? [String: String],
            let achievedFlag = document["achieved_flag"] as? Bool,
            let draftFlag = document["draft_flag"] as? Bool,
            let likeCount = document["like_count"] as? Int,
            let commentedCount = document["commented_count"] as? Int,
            let createdAt = document["created_at"] as? Timestamp
        else {
            self.user = UserEntity(document: ["": ""])
            self.genre = [""]
            self.newThings = ""
            self.goal = ["": ""]
            self.achievedFlag = false
            self.draftFlag = false
            self.likeCount = 0
            self.commentedCount = 0
            self.createdAt = Timestamp()
            return
        }
        
        self.user = user
        self.genre = genre
        self.newThings = newThings
        self.goal = goal
        self.achievedFlag = achievedFlag
        self.draftFlag = draftFlag
        self.likeCount = likeCount
        self.commentedCount = commentedCount
        self.createdAt = createdAt
    }
}
