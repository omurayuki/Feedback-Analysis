import Foundation

struct GoalsTranslater {
    
    func translate(_ entities: [GoalEntity]) -> [Timeline] {
        return entities.map { GoalTranslater().translate($0) }
    }
}

fileprivate struct GoalTranslater {
    
    func translate(_ entity: GoalEntity) -> Timeline {
        return Timeline(entity: entity)
    }
}
