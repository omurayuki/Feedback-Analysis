import Foundation

struct Timeline {
    let userImage: String
    let name: String
    let genre1: String?
    let genre2: String?
    let time: String
    let newThings: String
    let goal1: String?
    let goal2: String?
    let goal3: String?
    let deadLine: String
    let postImage: [String]?
    let achievedFlag: Bool
    let draftFlag: Bool
    let commentedCount: Int
    let likeCount: Int
    
    init(entity: GoalEntity) {
        self.userImage = entity.user.userImage
        self.name = entity.user.name
        self.genre1 = entity.genre["genre1"]
        self.genre2 = entity.genre["genre2"]
        self.time = "5時間前"
        self.newThings = entity.newThings
        self.goal1 = entity.goal["goal1"]
        self.goal2 = entity.goal["goal2"]
        self.goal3 = entity.goal["goal3"]
        self.deadLine = entity.deadLine
        self.postImage = nil
        self.achievedFlag = entity.achievedFlag
        self.draftFlag = entity.draftFlag
        self.commentedCount = entity.commentedCount
        self.likeCount = entity.likeCount
    }
}
