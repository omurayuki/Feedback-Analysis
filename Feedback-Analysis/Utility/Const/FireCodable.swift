import UIKit

protocol FireStorageCodable {
    
    var id: String { get set }
    var message: String? { get set }
    var content: String? { get set }
    var contentType: ContentType { get set }
    var time: Date { get set }
    var ownerID: String? { get set }
    var profilePicLink: String? { get set }
    var profilePic: UIImage? { get set }
    
}
