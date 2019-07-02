import Foundation

struct CommentsTranslator: Translator {
    
    func translate(_ entities: [CommentEntity]) -> [Comment] {
        return entities.map { CommentTranslator().translate($0) }
    }
}

fileprivate struct CommentTranslator {
    
    func translate(_ entity: CommentEntity) -> Comment {
        return Comment(entity: entity)
    }
}
