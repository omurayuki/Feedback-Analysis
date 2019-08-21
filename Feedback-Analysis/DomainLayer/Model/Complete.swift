import Foundation

struct Complete {
    
    let actualAchievement: [String]
    let analysis: [String]
    let strength: String
    let goalDocumentId: String
    let documentId: String
    let goal1: String
    let goal2: String
    let goal3: String
    let time: String
    
    init(entity: CompleteEntity) {
        actualAchievement = entity.actualAchievement
        analysis = entity.analysis
        strength = entity.strength
        goalDocumentId = entity.goalDocumentId
        time = entity.createdAt.dateValue().offsetFrom()
        documentId = entity.documentId
        goal1 = entity.goal1
        goal2 = entity.goal2
        goal3 = entity.goal3
    }
    
    init(achoevement: [String], analysis: [String], strength: String, goalDocumentId: String, documentId: String, goal1: String, goal2: String, goal3: String, time: String) {
        self.actualAchievement = achoevement
        self.analysis = analysis
        self.strength = strength
        self.goalDocumentId = goalDocumentId
        self.documentId = documentId
        self.goal1 = goal1
        self.goal2 = goal2
        self.goal3 = goal3
        self.time = time
    }
}
