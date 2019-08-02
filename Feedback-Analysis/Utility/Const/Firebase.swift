import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

enum FirebaseError: Error {
    case networkError
    case resultError(Error)
    case unknown
}

enum FirestoreResponse<T> {
    case success(T)
    case failure(Error)
    case unknown
}

enum ContentType: Int {
    case none
    case photo
    case unknown
}

enum FirestoreCollectionReference: String {
    case users = "Users"
    case conversations = "Conversations"
    case messages = "Messages"
}

enum FirebaseDocumentRef {
    case userRef(authorToken: String)
    case authorRef(authorToken: String)
    case goalPostRef(authorToken: String)
    case goalUpdateRef(author_token: String, goalDocument: String)
    case commentUpdateRef(goalDocument: String, commentDocument: String)
    case commentRef(goalDocument: String)
    case replyRef(commentDocument: String)
    case likeUserRef(goalDocument: String, authorToken: String)
    case likeCommentRef(commentDocument: String, authorToken: String)
    case messageRef(conversationID: String, messageID: String)
    //// subject = 主体, object = 客体
    case followRef(subject: String, object: String)
    case conversationRef(conversationID: String)
    
    var destination: DocumentReference {
        switch self {
        case .userRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
        case .authorRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
        case .goalPostRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
                .document()
        case .goalUpdateRef(let token, let documentId):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
                .document(documentId)
        case .commentUpdateRef(let documentId, let commentId):
            return Firestore.firestore()
                .collection("Goals")
                .document(documentId)
                .collection("Comments")
                .document(commentId)
        case .commentRef(let documentId):
            return Firestore.firestore()
                .collection("Goals")
                .document(documentId)
                .collection("Comments")
                .document()
        case .replyRef(let commentDocumentId):
            return Firestore.firestore()
                .collection("Comments")
                .document(commentDocumentId)
                .collection("Replies")
                .document()
        case .likeUserRef(let documentId, let token):
            return Firestore.firestore()
                .collection("Goals")
                .document(documentId)
                .collection("likeUsers")
                .document(token)
        case .likeCommentRef(let commentId, let token):
            return Firestore.firestore()
                .collection("Comments")
                .document(commentId)
                .collection("likeUsers")
                .document(token)
        case .followRef(let subjectToken, let objectToken):
            return Firestore.firestore()
                .collection("Follows")
                .document(subjectToken)
                .collection("Following")
                .document(objectToken)
        case .messageRef(let conversationID, let messageID):
            return Firestore.firestore()
                .collection("Conversations")
                .document(conversationID)
                .collection("Messages")
                .document(messageID)
        case .conversationRef(let conversationID):
            return Firestore.firestore()
                .collection("Conversations")
                .document(conversationID)
        }
    }
}

enum FirebaseCollectionRef {
    case goalsRef(authorToken: String)
    
    var destination: CollectionReference {
        switch self {
        case .goalsRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
        }
    }
}

enum FirebaseQueryRef {
    case publicGoalRef
    case publicCompleteRef
    case goalRef(authorToken: String)
    case completeRef(authorToken: String)
    case draftRef(authorToken: String)
    case allRef(authorToken: String)
    case commentRef(goalDocument: String)
    case replyRef(commentDocument: String)
    case followeeRefFromOtherPerson
    case followerRefFromOtherPerson
    case followeeRefFromMypage
    case followerRefFromMypage
    case conversationsRef
    case messagesRef(conversationId: String)
    
    var destination: Query {
        switch self {
        case .publicGoalRef:
            return Firestore.firestore()
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: false)
                .whereField("draft_flag", isEqualTo: false)
                .order(by: "updated_at", descending: true)
        case .publicCompleteRef:
            return Firestore.firestore()
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: true)
                .whereField("draft_flag", isEqualTo: false)
                .order(by: "updated_at", descending: true)
        case .goalRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: false)
                .whereField("draft_flag", isEqualTo: false)
                .order(by: "updated_at", descending: true)
        case .completeRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: true)
                .whereField("draft_flag", isEqualTo: false)
                .order(by: "updated_at", descending: true)
        case .draftRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: false)
                .whereField("draft_flag", isEqualTo: true)
                .order(by: "updated_at", descending: true)
        case .allRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
                .order(by: "updated_at", descending: true)
        case .commentRef(let documentId):
            return Firestore.firestore()
                .collection("Goals")
                .document(documentId)
                .collection("Comments")
                .order(by: "updated_at", descending: true)
        case .replyRef(let commentDocumentId):
            return Firestore.firestore()
                .collection("Comments")
                .document(commentDocumentId)
                .collection("Replies")
                .order(by: "updated_at", descending: true)
        case .followeeRefFromOtherPerson:
            return Firestore.firestore()
                .collection("Follows")
                .document(AppUserDefaults.getObjectToken())
                .collection("Following")
                .order(by: "created_at", descending: true)
        case .followerRefFromOtherPerson:
            return Firestore.firestore()
                .collection("Follows")
                .document(AppUserDefaults.getObjectToken())
                .collection("Follower")
                .order(by: "created_at", descending: true)
        case .followeeRefFromMypage:
            return Firestore.firestore()
                .collection("Follows")
                .document(AppUserDefaults.getAuthToken())
                .collection("Following")
                .order(by: "created_at", descending: true)
        case .followerRefFromMypage:
            return Firestore.firestore()
                .collection("Follows")
                .document(AppUserDefaults.getAuthToken())
                .collection("Follower")
                .order(by: "created_at", descending: true)
        case .conversationsRef:
            return Firestore.firestore()
                .collection("Conversations")
                .whereField("userIDs", arrayContains: AppUserDefaults.getAuthToken())
                .order(by: "updated_at", descending: true)
        case .messagesRef(let conversationId):
            return Firestore.firestore()
                .collection("Conversations")
                .document(conversationId)
                .collection("Messages")
                .order(by: "created_at", descending: false)
        }
    }
    
    var isFollow: Bool {
        switch self {
        case .followeeRefFromOtherPerson: return true
        case .followeeRefFromMypage:      return true
        case .followerRefFromOtherPerson: return false
        case .followerRefFromMypage:      return false
        default:                          return false
        }
    }
    
    var isMypage: Bool {
        switch self {
        case .followeeRefFromOtherPerson: return false
        case .followerRefFromOtherPerson: return false
        case .followeeRefFromMypage:      return true
        case .followerRefFromMypage:      return true
        default:                          return false
        }
    }
}

enum FirebaseStorageRef {
    case userImageRef(authorToken: String)
    
    var destination: StorageReference {
        switch self {
        case .userImageRef(let token):
            return Storage.storage()
                .reference()
                .child("icon")
                .child(token)
        }
    }
}
