import Foundation

struct ConversationsTranslator {
    
    func translate(_ entities: [ConversationEntity]) -> [Conversation] {
        return entities.map { ConversationTranslator().translate($0) }
    }
}

fileprivate struct ConversationTranslator {
    
    func translate(_ entity: ConversationEntity) -> Conversation {
        return Conversation(entity: entity)
    }
}
