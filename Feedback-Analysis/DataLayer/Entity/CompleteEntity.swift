import Foundation
import FirebaseFirestore

struct CompleteEntity: Entity {
    
    let actualAchievement: [String]
    let analysis: [String]
    let strength: String
    let goalDocumentId: String
    let createdAt: Timestamp
    let documentId: String
    let goal1: String
    let goal2: String
    let goal3: String
    
    init(document: [String: Any], documentId: String) {
        guard
            let actualAchievement = document["actual_achievement"] as? [String],
            let analysis = document["analysis"] as? [String],
            let strength = document["strength"] as? String,
            let goalDocumentId = document["goal_document_id"] as? String,
            let goal1 = document["goal1"] as? String,
            let goal2 = document["goal2"] as? String,
            let goal3 = document["goal3"] as? String,
            let createdAt = document["created_at"] as? Timestamp
        else {
            self.actualAchievement = [String]()
            self.analysis = [String]()
            self.strength = ""
            self.goalDocumentId = ""
            self.createdAt = Timestamp()
            self.documentId = ""
            self.goal1 = ""
            self.goal2 = ""
            self.goal3 = ""
            return
        }
        
        self.actualAchievement = actualAchievement
        self.analysis = analysis
        self.strength = strength
        self.goalDocumentId = goalDocumentId
        self.createdAt = createdAt
        self.documentId = documentId
        self.goal1 = goal1
        self.goal2 = goal2
        self.goal3 = goal3
    }
}
