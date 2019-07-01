import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

enum FirebaseError: Error {
    case networkError
    case resultError(Error)
    case unknown
}

enum FirebaseDocumentRef {
    case userRef
    case goalPostRef
    case goalUpdateRef(String)
    
    var destination: DocumentReference {
        switch self {
        case .userRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
        case .goalPostRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
                .document()
        case .goalUpdateRef(let documentId):
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
                .document(documentId)
        }
    }
}

enum FirebaseCollectionRef {
    case goalsRef
    
    var destination: CollectionReference {
        switch self {
        case .goalsRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
        }
    }
}

enum FirebaseQueryRef {
    case goalRef
    case completeRef
    case draftRef
    case allRef
    
    var destination: Query {
        switch self {
        case .goalRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: false)
                .whereField("draft_flag", isEqualTo: false)
                .order(by: "updated_at", descending: true)
        case .completeRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: true)
                .whereField("draft_flag", isEqualTo: false)
                .order(by: "updated_at", descending: true)
        case .draftRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
                .whereField("achieved_flag", isEqualTo: false)
                .whereField("draft_flag", isEqualTo: true)
                .order(by: "updated_at", descending: true)
                
        case .allRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
                .order(by: "updated_at", descending: true)
        }
    }
}

enum FirebaseStorageRef {
    case userImageRef
    
    var destination: StorageReference {
        switch self {
        case .userImageRef:
            return Storage.storage()
                .reference()
                .child("icon")
                .child(AppUserDefaults.getAuthToken())
        }
    }
}

struct Initial {
    static let userData = ["name": "未設定", "content": "紹介文を記入しましょう",
                           "residence": "未設定", "birth": "未設定",
                           "follow": 0, "follower": 0,
                           "header_image": "https://firebasestorage.googleapis.com/v0/b/feedback-analysis-459a6.appspot.com/o/header_default.png?alt=media&token=890e5de0-a8da-4645-b861-197fc6dafea9",
                           "user_image": "https://firebasestorage.googleapis.com/v0/b/feedback-analysis-459a6.appspot.com/o/icon_default.png?alt=media&token=71c25446-ae68-4dd6-bb97-f852ff87c763",
                           "created_at": FieldValue.serverTimestamp()] as [String : Any]
}
