import Foundation

struct GoalsTranslator {
    
    func translate(_ entities: [GoalEntity]) -> [Timeline] {
        return entities.map { GoalTranslator().translate($0) }
    }
}

fileprivate struct GoalTranslator {
    
    func translate(_ entity: GoalEntity) -> Timeline {
        return Timeline(entity: entity)
    }
}
