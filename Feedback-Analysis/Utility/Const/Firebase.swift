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
    case authorRef(authorToken: String)
    case goalPostRef
    case goalUpdateRef(author_token: String, goalDocument: String)
    case commentRef(goalDocument: String)
    case likeUserRef(goalDocument: String)
    
    var destination: DocumentReference {
        switch self {
        case .userRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
        case .authorRef(let token):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
        case .goalPostRef:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaults.getAuthToken())
                .collection("Goals")
                .document()
        case .goalUpdateRef(let token, let documentId):
            return Firestore.firestore()
                .collection("Users")
                .document(token)
                .collection("Goals")
                .document(documentId)
        case .commentRef(let documentId):
            return Firestore.firestore()
                .collection("Goals")
                .document(documentId)
                .collection("Comments")
                .document()
        case .likeUserRef(let documentId):
            return Firestore.firestore()
                .collection("Goals")
                .document(documentId)
                .collection("likeUsers")
                .document(AppUserDefaults.getAuthToken())
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
    case commentRef(goalDocument: String)
    
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
        case .commentRef(let documentId):
            return Firestore.firestore()
                .collection("Goals")
                .document(documentId)
                .collection("Comments")
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
