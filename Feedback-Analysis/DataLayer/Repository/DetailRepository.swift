import Foundation
import RxSwift

protocol DetailRepository {
    func fetch() -> Single<AccountEntity>
    func post(to documentRef: FirebaseDocumentRef, comment: Comment) -> Single<()>
}

struct DetailRepositoryImpl: DetailRepository {
    
    static let shared = DetailRepositoryImpl()
    
    private let dataStore = DetailDataStoreFactory.createDetailDataStore()
    
    func fetch() -> Single<AccountEntity> {
        return dataStore.fetch()
    }
    
    func post(to documentRef: FirebaseDocumentRef, comment: Comment) -> Single<()> {
        return dataStore.post(to: documentRef, comment: comment)
    }
}
