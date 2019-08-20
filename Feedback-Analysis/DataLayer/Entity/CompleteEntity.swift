import Foundation
import FirebaseFirestore

struct CompleteEntity: Entity {
    
    let actualAchievement: [String]
    let analysis: [String]
    let strength: String
    let goalDocumentId: String
    let createdAt: Timestamp
    let documentId: String
    
    init(document: [String: Any], documentId: String) {
        guard
            let actualAchievement = document["actual_achievement"] as? [String],
            let analysis = document["analysis"] as? [String],
            let strength = document["strength"] as? String,
            let goalDocumentId = document["goal_document_id"] as? String,
            let createdAt = document["created_at"] as? Timestamp
        else {
            self.actualAchievement = [String]()
            self.analysis = [String]()
            self.strength = ""
            self.goalDocumentId = ""
            self.createdAt = Timestamp()
            self.documentId = ""
            return
        }
        
        self.actualAchievement = actualAchievement
        self.analysis = analysis
        self.strength = strength
        self.goalDocumentId = goalDocumentId
        self.createdAt = createdAt
        self.documentId = documentId
    }
}
