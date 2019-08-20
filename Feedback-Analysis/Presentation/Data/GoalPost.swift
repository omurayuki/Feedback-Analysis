import Foundation
import FirebaseFirestore

struct GoalPost {
    let genre: [String: String]
    let newThings: String
    let goal: [String: String]
    let deadline: Date
    let achievedFlag: Bool
    let draftFlag: Bool
    let likeCount: Int
    let commentedCount: Int
    let authorToken: String
    let createdAt: FieldValue
    let updatedAt: FieldValue
    
    fileprivate enum Key {
        case genre
        case newThings
        case goal
        case deadline
        case achievedFlag
        case draftFlag
        case likeCount
        case commentedCount
        case authorToken
        case createdAt
        case updatedAt
        
        var description: String {
            switch self {
            case .genre:           return "genre"
            case .newThings:       return "new_things"
            case .goal:            return "goal"
            case .deadline:        return "deadline"
            case .achievedFlag:    return "achieved_flag"
            case .draftFlag:       return "draft_flag"
            case .likeCount:       return "like_count"
            case .commentedCount:  return "commented_count"
            case .authorToken:     return "author_token"
            case .createdAt:       return "created_at"
            case .updatedAt:       return "updated_at"
            }
        }
    }
    
    func encode() -> [String: Any] {
        return [Key.genre.description: genre,
                Key.newThings.description: newThings,
                Key.goal.description: goal,
                Key.deadline.description: deadline,
                Key.achievedFlag.description: achievedFlag,
                Key.draftFlag.description: draftFlag,
                Key.likeCount.description: likeCount,
                Key.commentedCount.description: commentedCount,
                Key.authorToken.description: authorToken,
                Key.createdAt.description: createdAt,
                Key.updatedAt.description: updatedAt]
    }
}
