import Foundation
import FirebaseFirestore

struct GoalPost {
    let genre: [String]
    let newThings: String
    let goal: [String: String]
    let achievedFlag: Bool
    let draftFlag: Bool
    let likeCount: Int
    let commentedCount: Int
    let createdAt: FieldValue
    
    fileprivate enum Key {
        case genre
        case newThings
        case goal
        case achievedFlag
        case draftFlag
        case likeCount
        case commentedCount
        case createdAt
        
        var description: String {
            switch self {
            case .genre:           return "genre"
            case .newThings:       return "new_things"
            case .goal:            return "goal"
            case .achievedFlag:    return "achieved_flag"
            case .draftFlag:       return "draft_flag"
            case .likeCount:       return "like_count"
            case .commentedCount:  return "commented_count"
            case .createdAt:       return "created_at"
            }
        }
    }
    
    func encode() -> [String: Any] {
        return [Key.genre.description: genre,
                Key.newThings.description: newThings,
                Key.goal.description: goal,
                Key.achievedFlag.description: achievedFlag,
                Key.draftFlag.description: draftFlag,
                Key.likeCount.description: likeCount,
                Key.commentedCount.description: commentedCount,
                Key.createdAt.description: createdAt]
    }
}
