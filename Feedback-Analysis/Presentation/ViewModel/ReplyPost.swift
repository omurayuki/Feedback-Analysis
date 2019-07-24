import Foundation
import FirebaseFirestore

struct ReplyPost {
    let authorToken: String
    let reply: String
    let createdAt: FieldValue
    let updatedAt: FieldValue
    
    fileprivate enum Key {
        case authorToken
        case reply
        case createdAt
        case updatedAt
        
        var description: String {
            switch self {
            case .authorToken:    return "author_token"
            case .reply:      return "reply"
            case .createdAt:    return "created_at"
            case .updatedAt:    return "updated_at"
            }
        }
    }
    
    func encode() -> [String: Any] {
        return [Key.authorToken.description: authorToken,
                Key.reply.description: reply,
                Key.createdAt.description: createdAt,
                Key.updatedAt.description: updatedAt]
    }
}
