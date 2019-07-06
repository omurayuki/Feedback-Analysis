import Foundation

struct RepliesTranslator: Translator {
    
    func translate(_ entities: [ReplyEntity]) -> [Reply] {
        return entities.map { ReplyTranslator().translate($0) }
    }
}

fileprivate struct ReplyTranslator {
    
    func translate(_ entity: ReplyEntity) -> Reply {
        return Reply(entity: entity)
    }
}
