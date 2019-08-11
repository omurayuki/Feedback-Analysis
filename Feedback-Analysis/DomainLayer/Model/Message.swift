import Foundation
import FirebaseFirestore
import UIKit

struct Message: FireStorageCodable {
    var id: String
    var message: String?
    var content: String?
    var contentType: ContentType
    var time: Date
    var ownerID: String?
    var profilePicLink: String?
    var profilePic: UIImage?
    
    init(entity: MessageEntity) {
        self.id = entity.id
        self.message = entity.message
        self.content = entity.content
        self.contentType = ContentType(rawValue: entity.contentType) ?? .unknown
        self.time = entity.createdAt.dateValue()
        self.ownerID = entity.ownerID
        self.profilePicLink = entity.profilePicLink
        self.profilePic = nil
    }
    
    //// messageボタンをタップされた時
    init(message: String, ownerID: String) {
        self.id = UUID().uuidString
        self.message = message
        self.content = nil
        self.contentType = ContentType.none
        self.time = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        self.ownerID = ownerID
        self.profilePicLink = nil
        self.profilePic = nil
    }
    
    //// imageボタンをタップされた時
    init(contentType: ContentType, profilePic: UIImage, ownerID: String) {
        self.id = UUID().uuidString
        self.message = nil
        self.contentType = contentType
        self.time = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        self.ownerID = ownerID
        self.profilePicLink = nil
        self.profilePic = profilePic
    }
    
    //// imageをuploadした後に, profilePicImageをprofilePickLinkにする用
    init(contentType: ContentType, profilePicLink: String, ownerID: String) {
        self.id = UUID().uuidString
        self.message = nil
        self.contentType = contentType
        self.time = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        self.ownerID = ownerID
        self.profilePicLink = profilePicLink
        self.profilePic = nil
    }
}
