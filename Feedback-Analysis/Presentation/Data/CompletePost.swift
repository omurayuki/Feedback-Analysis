import Foundation
import FirebaseFirestore

struct CompletePost {
    let actualAchievement: [String]
    let analysis: [String]
    let strength: String
    let goalDocumentId: String
    let createdAt: FieldValue
    
    fileprivate enum Key {
        case actualAchievement
        case analysis
        case strength
        case goalDocumentId
        case createdAt
        
        var description: String {
            switch self {
            case .actualAchievement: return "actual_achievement"
            case .analysis:          return "analysis"
            case .strength:          return "strength"
            case .goalDocumentId:    return "goal_document_id"
            case .createdAt:         return "created_at"
            }
        }
    }
    
    func encode() -> [String: Any] {
        return [Key.actualAchievement.description: actualAchievement,
                Key.analysis.description: analysis,
                Key.strength.description: strength,
                Key.goalDocumentId.description: goalDocumentId,
                Key.createdAt.description: createdAt]
    }
}
