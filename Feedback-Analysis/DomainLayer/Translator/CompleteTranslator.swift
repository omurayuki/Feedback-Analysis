import Foundation

struct CompletesTranslator {
    
    func translate(_ entities: [CompleteEntity]) -> [Complete] {
        return entities.map { CompleteTranslator().translate($0) }
    }
}

fileprivate struct CompleteTranslator {
    
    func translate(_ entity: CompleteEntity) -> Complete {
        return Complete(entity: entity)
    }
}
