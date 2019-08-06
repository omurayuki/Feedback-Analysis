import Foundation

struct MessagesTranslator {
    
    func translate(_ entities: [MessageEntity]) -> [Message] {
        return entities.map { MessageTranslator().translate($0) }
    }
}

fileprivate struct MessageTranslator {
    
    func translate(_ entity: MessageEntity) -> Message {
        return Message(entity: entity)
    }
}
