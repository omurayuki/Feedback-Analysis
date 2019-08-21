import Foundation
import FirebaseFirestore

struct CompletePost {
    let actualAchievement: [String]
    let analysis: [String]
    let strength: String
    let goalDocumentId: String
    let goal1: String
    let goal2: String
    let goal3: String
    let createdAt: FieldValue
    
    fileprivate enum Key {
        case actualAchievement
        case analysis
        case strength
        case goalDocumentId
        case goal1
        case goal2
        case goal3
        case createdAt
        
        var description: String {
            switch self {
            case .actualAchievement: return "actual_achievement"
            case .analysis:          return "analysis"
            case .strength:          return "strength"
            case .goalDocumentId:    return "goal_document_id"
            case .goal1:              return "goal1"
            case .goal2:              return "goal2"
            case .goal3:              return "goal3"
            case .createdAt:         return "created_at"
            }
        }
    }
    
    func encode() -> [String: Any] {
        return [Key.actualAchievement.description: actualAchievement,
                Key.analysis.description: analysis,
                Key.strength.description: strength,
                Key.goalDocumentId.description: goalDocumentId,
                Key.goal1.description: goal1,
                Key.goal2.description: goal2,
                Key.goal3.description: goal3,
                Key.createdAt.description: createdAt]
    }
}
