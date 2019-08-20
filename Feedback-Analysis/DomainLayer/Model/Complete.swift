import Foundation

struct Complete {
    
    let actualAchievement: [String]
    let analysis: [String]
    let strength: String
    let goalDocumentId: String
    let documentId: String
    let time: String
    
    init(entity: CompleteEntity) {
        actualAchievement = entity.actualAchievement
        analysis = entity.analysis
        strength = entity.strength
        goalDocumentId = entity.goalDocumentId
        time = entity.createdAt.dateValue().offsetFrom()
        documentId = entity.documentId
    }
    
    init(achoevement: [String], analysis: [String], strength: String, goalDocumentId: String, documentId: String, time: String) {
        self.actualAchievement = achoevement
        self.analysis = analysis
        self.strength = strength
        self.goalDocumentId = goalDocumentId
        self.documentId = documentId
        self.time = time
    }
}
