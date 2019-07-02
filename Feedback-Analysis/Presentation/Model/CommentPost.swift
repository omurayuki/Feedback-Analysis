import Foundation
import FirebaseFirestore

struct CommentPost {
    let authorToken: String
    let comment: String
    let likeCount: Int
    let repliedCount: Int
    let createdAt: FieldValue
    let updatedAt: FieldValue
    
    fileprivate enum Key {
        case authorToken
        case comment
        case likeCount
        case repliedCount
        case createdAt
        case updatedAt
        
        var description: String {
            switch self {
            case .authorToken:    return "author_token"
            case .comment:      return "comment"
            case .likeCount:    return "like_count"
            case .repliedCount: return "replied_count"
            case .createdAt:    return "created_at"
            case .updatedAt:    return "updated_at"
            }
        }
    }
    
    func encode() -> [String: Any] {
        return [Key.authorToken.description: authorToken,
                Key.comment.description: comment,
                Key.likeCount.description: likeCount,
                Key.repliedCount.description: repliedCount,
                Key.createdAt.description: createdAt,
                Key.updatedAt.description: updatedAt]
    }
}
