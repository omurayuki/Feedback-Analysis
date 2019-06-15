import Foundation
import Firebase
import FirebaseFirestore

enum FirebaseError: Error {
    case networkError
    case resultError(Error)
    case unknown
}

enum FirebaseDocumentRef {
    case userRef
    
    var destination: DocumentReference {
        switch self {
        case .userRef:
            return Firestore.firestore()
                .collection("User")
                .document(AppUserDefaults.getAuthToken())
        }
    }
}

struct Initial {
    static let userData = ["name": "未設定", "content": "紹介文を記入しましょう",
                           "residence": "不明", "birth": "未設定",
                           "follow": 0, "follower": 0,
                           "created_at": FieldValue.serverTimestamp()] as [String : Any]
}
