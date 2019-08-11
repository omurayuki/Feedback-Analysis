import Foundation
import Firebase
import FirebaseStorage

struct UploadImageManager {
    
    func uploadImage(_ image: UIImage, at storageRef: FirebaseStorageRef,
                     completion: @escaping (FirestoreResponse<URL>) -> Void) {
        guard let imageData = image.scale(to: CGSize(width: 350, height: 350))?.jpegData(compressionQuality: 0.3) else {
            completion(.unknown)
            return
        }
        storageRef
            .destination
            .putData(imageData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                storageRef
                    .destination
                    .downloadURL(completion: { (url, error) in
                        if let error = error {
                            completion(.failure(error))
                        }
                        guard let url = url else {
                            completion(.unknown)
                            return
                        }
                        completion(.success(url))
                    })
            })
    }
    
    func upload(_ object: Message, reference: FirestoreCollectionReference,
                   completion: @escaping (FirestoreResponse<Message>) -> Void) {
        guard let imageData = object.profilePic?.scale(to: CGSize(width: 350, height: 350))?.jpegData(compressionQuality: 0.3) else {
            completion(.success(object))
            return
        }
        let ref = Storage.storage().reference().child(reference.rawValue).child(object.id).child(object.id + ".jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpg"
        ref.putData(imageData, metadata: uploadMetadata) { (_, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            ref.downloadURL(completion: { url, error in
                if let error = error {
                    completion(.failure(error))
                }
                if let downloadURL = url?.absoluteString {
                    guard let ownerID = object.ownerID else { return }
                    let uploadedObject = Message(contentType: object.contentType, profilePicLink: downloadURL, ownerID: ownerID)
                    completion(.success(uploadedObject))
                    return
                }
            })
        }
    }
}
