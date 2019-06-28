import Foundation
import RxSwift

protocol GoalDataStore {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from documentRef: FirebaseCollectionRef) -> Observable<[GoalEntity]>
}

struct GoalDataStoreImpl: GoalDataStore {
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return Provider().setData(documentRef: documentRef, fields: fields.encode())
    }
    
    func fetch(from documentRef: FirebaseCollectionRef) -> Observable<[GoalEntity]> {
        return Observable.create({ observer -> Disposable in
            documentRef
                .destination
                .order(by: "updated_at", descending: true)
                .addSnapshotListener({ goalsSnapshot, error in
                if let error = error {
                    observer.on(.error(FirebaseError.resultError(error)))
                    return
                }
                FirebaseDocumentRef
                    .userRef
                    .destination
                    .addSnapshotListener({ userSnapshot, error in
                    if let error = error {
                        observer.on(.error(FirebaseError.resultError(error)))
                        return
                    }
                    guard let userDocument = userSnapshot?.data() else {
                        observer.on(.error(FirebaseError.unknown))
                        return
                    }
                    guard let documents = goalsSnapshot?.documents else {
                        observer.on(.error(FirebaseError.unknown))
                        return
                    }
                    observer.on(.next(documents.compactMap { GoalEntity(user: UserEntity(document: userDocument), document: $0.data()) }))
                })
            })
            return Disposables.create()
        })
    }
}

struct GoalDataStoreFactory {
    
    static func createGoalDataStore() -> GoalDataStore {
        return GoalDataStoreImpl()
    }
}
