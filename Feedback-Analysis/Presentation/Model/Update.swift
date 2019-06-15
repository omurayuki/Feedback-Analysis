import Foundation

struct Update {
    let name: String
    let content: String
    let residence: String
    let birth: String
    
    enum Key {
        case name
        case content
        case residence
        case birth
        
        var description: String {
            switch self {
            case .name:       return "name"
            case .content:    return "content"
            case .residence:  return "residence"
            case .birth:      return "birth"
            }
        }
    }
    
    func encode() -> [String: Any] {
        return [Key.name.description: name,
                Key.content.description: content,
                Key.residence.description: residence,
                Key.birth.description: birth,]
    }
}
